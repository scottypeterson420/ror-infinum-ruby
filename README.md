# Rubocop Infinum

This gem provides the .RuboCop configuration file alongside some custom cops used at Infinum.

To use it, you can add this to your `Gemfile` (`group :development`):

  ~~~ruby
  gem 'rubocop-infinum', require: false
  ~~~

And add to the top of your project's RuboCop configuration file:

  ~~~yml
  inherit_gem:
    rubocop-infinum: .rubocop.yml

  require: rubocop-infinum
  ~~~

If you dislike some rules, please check [RuboCop's documentation](https://rubocop.readthedocs.io/en/latest/configuration/#inheriting-configuration-from-a-dependency-gem) on inheriting configuration from a gem.
