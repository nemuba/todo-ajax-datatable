# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# ruby '2.7.8'

gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.3'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
# gem 'mini_racer', platforms: :ruby
gem 'actioncable', '~> 5.2'
gem 'activerecord-import'
gem 'ajax-datatables-rails'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'bootstrap', '~> 4.3.1'
gem 'cocoon'
gem 'coffee-rails', '~> 4.2'
gem 'draper'
gem 'flag-icons-rails'
gem 'font-awesome-sass', '~> 6.5.1'
gem 'jbuilder', '~> 2.5'
gem 'jquery-datatables'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'material_icons'
gem 'rails-i18n'
gem 'redis', '~> 4.0'
gem 'sidekiq'
gem 'turbolinks', '~> 5'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

group :development do
  gem 'foreman'
end

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 5.2'
  gem 'faker', '~> 2.21.0'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 4.0'
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'shoulda-matchers', '~> 4.5'
end

group :test do
  gem 'database_cleaner-active_record', '~> 2.0'
  gem 'simplecov', require: false
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
