# frozen_string_literal: true

require 'open-uri'
require 'i18n'

module I18n
  module Backend
    # I18n Backend class allowed to use remote translations
    class Remote
      include I18n::Backend::Base

      def translations
        @translations || fetch_translations
      end

      def available_locales
        @available_locales || set_available_locales
      end

      def initialized?
        !@translations.nil?
      end

      def reload!
        fetch_translations

        true
      end

      def translate(locale, key, options = EMPTY_HASH)
        split_keys = I18n.normalize_keys(locale, key, options[:scope], options[:separator])

        val = translations.dig(*split_keys)

        if val.nil? && options[:fallback] && locale != I18n.default_locale
          alternate_split_keys = split_keys.dup
          alternate_split_keys[0] = I18n.default_locale

          val = translations.dig(*alternate_split_keys)
        end

        val
      end

      private

      def fetch_translations
        @translations = Concurrent::Hash.new ### Must ensure is a Concurrent::Hash as per i18n-ruby standards

        I18n.config.remote_translations.each do |url|
          data = URI.parse(url).open.read
          @temporary_translations = JSON.parse(data, { symbolize_names: true })
          @translations.merge!(@temporary_translations)
        rescue StandardError => e
          puts "Error processing translations url: #{url}. Error message: #{e.message}"

          next
        end

        @translations
      end

      def set_available_locales
        @available_locales = translations.keys.map(&:to_sym)
      end
    end
  end
end
