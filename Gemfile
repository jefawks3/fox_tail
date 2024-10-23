# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in fox_tail.gemspec.
gemspec

gem "cssbundling-rails", "~> 1.1"
gem "faker"
gem "jsbundling-rails", "~> 1.1"
gem "lookbook", ">= 2.0.5"
gem "puma"
gem "rails", "~> 7.0"
gem "sprockets-rails", "~> 3.4"
gem "sqlite3"
gem "view_component", "~> 3.0"

group :development, :test do
  gem "capybara"
  gem "faraday"
  gem "listen"
  gem "rubocop", require: false
  gem "rubocop-minitest", require: false
  gem "standard", require: false
  gem "rubocop-md", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-capybara", require: false
  gem "rubyzip"
end

# Start debugger with binding.b [https://github.com/ruby/debug]
gem "debug", ">= 1.0.0"
