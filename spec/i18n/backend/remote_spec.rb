# frozen_string_literal: true

require 'spec_helper'
require 'i18n/backend/remote'

RSpec.describe I18n::Backend::Remote do
  let(:translations) do
    {
      en: {
        greeting: 'Hello!',
        welcome: 'Welcome, %<name>s!'
      },
      fr: {
        welcome: 'Bienvenue, %<name>s!'
      }
    }
  end

  let(:json_translations) do
    {
      en: {
        greeting: 'Hello!',
        welcome: 'Welcome, %<name>s!'
      }
    }
  end

  let(:remote_url) { 'http://www.example.com/translations.json' }

  before do
    allow(I18n.config).to receive(:remote_translations).and_return([remote_url])
    allow_any_instance_of(URI::HTTP).to receive(:open).and_return(StringIO.new(translations.to_json))
  end

  describe '#translations' do
    context 'when translations have not been fetched yet' do
      it 'fetches translations from remote and returns them' do
        expect(subject.translations).to eq(translations)
      end
    end

    context 'when translations have been fetched before' do
      before { subject.instance_variable_set('@translations', translations) }

      it 'returns the cached translations' do
        expect(subject.translations).to eq(translations)
      end
    end
  end

  describe '#available_locales' do
    before { subject.instance_variable_set('@translations', translations) }

    it 'returns the available locales' do
      expect(subject.available_locales).to eq(%i[en fr])
    end
  end

  describe '#initialized?' do
    context 'when translations have not been fetched yet' do
      it 'returns false' do
        expect(subject.initialized?).to be_falsey
      end
    end

    context 'when translations have been fetched' do
      before { subject.instance_variable_set('@translations', translations) }

      it 'returns true' do
        expect(subject.initialized?).to be_truthy
      end
    end
  end

  describe '#reload!' do
    before do
      subject.instance_variable_set('@translations', translations)
      allow_any_instance_of(URI::HTTP).to receive(:open).and_return(StringIO.new(json_translations.to_json))
    end

    it 'fetches translations again' do
      expect(subject).to receive(:fetch_translations)
      subject.reload!
    end

    it 'replaces the cached translations with the new ones' do
      subject.reload!
      expect(subject.instance_variable_get('@translations')).to eq(json_translations)
    end
  end

  describe '#translate' do
    context 'when translations are not present' do
      it 'returns nil' do
        expect(subject.translate(:en, :no_greeting)).to be_nil
      end
    end

    context 'when translation is present in remote translation file' do
      it 'returns the translated value' do
        expect(subject.translate(:en, :greeting)).to eq 'Hello!'
      end

      context 'when locale is not available in remote translation file' do
        it 'returns nil' do
          expect(subject.translate(:fr, :no_greeting)).to be_nil
        end
      end

      context 'when the given key is not present in remote translation file' do
        it 'returns nil' do
          expect(subject.translate(:en, :not_present_key)).to be_nil
        end
      end

      context 'when fallback is set to true' do
        context 'when translation is not present in remote translation file but available in default locale file' do
          it 'returns the translated value from default locale file' do
            expect(subject.translate(:fr, :greeting, fallback: true)).to eq 'Hello!'
          end
        end

        context 'when translation is not present in remote translation file and default locale file' do
          it 'returns nil' do
            expect(subject.translate(:fr, :no_greeting, fallback: true)).to be_nil
          end
        end
      end
    end
  end
end
