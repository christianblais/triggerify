source 'https://rubygems.org'
ruby "3.1.0"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1'
gem 'puma', '~> 5'
gem 'webpacker', '~> 5'
gem 'turbolinks', '~> 5'
# Use SCSS for stylesheets
# gem 'sass-rails', '>= 6'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'net-imap', require: false
gem 'net-pop', require: false
gem 'net-smtp', require: false
gem 'bootsnap', '>= 1.4.2', require: false

gem 'pg'
gem 'skylight'
gem 'twilio-ruby'
gem 'slack-ruby-client'
gem 'dogapi'
gem 'twitter'
gem 'sendgrid-ruby'

gem 'shopify_app', '~> 18'
gem 'react-rails'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console'
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem "bugsnag", "~> 6.13"

group :test do
  gem 'capybara', '>= 2.15'
  gem 'mocha'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
