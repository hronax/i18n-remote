# frozen_string_literal: true

require 'i18n/config'

module I18nRemote
  module Config
    # returns array of remote translation links
    def remote_translations
      @@remote_translations
    end

    # Sets an array of remote translations
    def remote_translations=(remote_translations)
      @@remote_translations = remote_translations
    end
  end
end
