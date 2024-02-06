source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in fox_tail.gemspec.
gemspec

gem "rails", "~> 7.0"
gem "view_component", "~> 3.0"
gem 'cssbundling-rails', '~> 1.1'
gem 'jsbundling-rails', '~> 1.1'
gem 'sprockets-rails', '~> 3.4'
gem "puma"
gem "sqlite3"
gem "lookbook", ">= 2.0.5"
gem "faker"

group :development, :test do
  gem "rubocop"
  gem "rubocop-minitest"
  gem "faraday"
  gem "capybara"
  gem "listen"
  gem "rubyzip"
end

# Start debugger with binding.b [https://github.com/ruby/debug]
gem "debug", ">= 1.0.0"
