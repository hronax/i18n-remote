# frozen_string_literal: true

require 'i18n/config'
require 'i18n-remote/backend/remote'
require 'i18n-remote/config'

module I18n
  class Config
    include I18nRemote::Config
  end
end
