# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'i18n-remote'
  spec.version       = '0.1.0'
  spec.authors       = ['hronax']
  spec.email         = ['zhr0n4x@gmail.com']
  spec.summary       = 'A Ruby gem that extends the I18n gem with support for fetching translations from remote files.'
  spec.homepage      = 'https://github.com/hronax/i18n-remote'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.require_paths = ['lib']

  spec.add_dependency 'i18n', '~> 1.0'
  spec.add_dependency 'open-uri'

  spec.add_development_dependency 'bundler', '~> 2.2'
  spec.add_development_dependency 'rspec', '~> 3.10'

  spec.required_ruby_version = '~> 3.0'
end
