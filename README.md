# I18nRemote

Welcome to our new gem that extend native functionality of I18n

## Installation

Add `gem 'i18n-remote', git: 'git://github.com/hronax/i18n-remote.git'` to your gemfile

run `bundle install`

create file `config/initializers/i18n.rb` with code:

`I18n.backend = I18n::Backend::Chain.new(I18nRemote::Backend::Remote.new, I18n.backend)
I18n.config.remote_translations = %w[
https://sample.com/en.json
https://sample.com/fr.json
]`

Change links above with your links with translations in json format

To enable fallbacks add next line to your `application.rb`:

`config.i18n.fallbacks = true`

## Usage

Enjoy your remote translations in your project

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the I18n::Remote project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/i18n-remote/blob/main/CODE_OF_CONDUCT.md).
