source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

# Production-enviroment-server
# gem 'puma'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem "jquery-ui-rails", "~> 4.0.5"

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

gem 'modernizr-rails'

#handles excel and csv docs
gem 'roo'

# Use unicorn as the app server
# gem 'unicorn'

# Use foundation css/javascript with rails
gem 'foundation-rails', '5.4.3.1'

# Googlelogin
gem "omniauth-google-oauth2", "~> 0.2.1"

# Fileuploader
gem 'carrierwave'

# Imageresizer
gem 'mini_magick'

# Color-picker
gem 'jquery-minicolors-rails'

# Datatables
gem 'jquery-datatables-rails', git: 'git://github.com/rweng/jquery-datatables-rails.git'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# gon helps javascript get rails info
gem 'gon'

#i18n
gem 'i18n', github: 'svenfuchs/i18n'

# this gem is used for to be able to upload files if the form is Remote = True
gem 'remotipart'

# Automaticly makes links in a text (ex. in comments for events)
gem 'rails_autolink'

# Removes assets-logging in the console
gem 'quiet_assets', group: :development

group :production do
  gem 'rails_12factor'
  gem 'pg'
end

group :assets do
  gem 'foundation-icons-sass-rails'
end

group :development, :test do
  gem 'sqlite3'
end

gem "rspec-rails", :group => [:test, :development]
gem "database_cleaner"
gem 'nokogiri'
group :test do
 gem "factory_girl_rails"
 gem "capybara"
 gem "guard-rspec"
end