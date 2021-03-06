source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.1'

gem 'rails', '~> 5.2.0'
gem 'pg'
gem 'devise'
gem 'omniauth-google-oauth2'
gem 'omniauth-facebook'
gem 'thin'
gem 'city-state'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
gem "jquery-slick-rails"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.2.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
gem "aws-s3", :require => "aws/s3"
# gem "aws-sdk"
gem 'activerecord-import'
gem 'aws-sdk', '< 2.0'
gem 'jquery-rails'
gem 'shopify_app', '~> 7.2.9'
gem 'link_thumbnailer'
gem 'pry'
gem 'best_in_place'
gem "roo", "~> 2.7.0"
gem "cocoon"
gem 'jquery-datatables'
gem 'countries'
gem 'phony'
gem 'ransack'
gem 'whenever', require: false
gem 'listen', '>= 3.0.5', '< 3.2'
gem 'httparty'
gem 'google-cloud'
gem 'google-cloud-translate'
gem 'sidekiq'
gem 'bootsnap'
gem "aws-sdk-s3", require: false
gem "mini_magick"
gem 'paperclip'
gem 'ckeditor', github: 'galetahub/ckeditor'
gem 'friendly_id', '~> 5.2.4'
gem 'active_storage_validations'
gem 'sitemap_generator'
gem 'yt', '~> 0.29.1'
gem 'newrelic_rpm'
gem 'medium-editor-rails', '~> 2.3'
gem 'medium-editor-insert-plugin-rails'
gem 'local_time'
gem 'quilljs-rails'
gem "i18n-js"
# gem 'headless', '~> 2.2', '>= 2.2.3'
gem 'gibbon', :git => 'https://github.com/amro/gibbon.git'
gem "lazyload-rails"
gem 'redis'
gem 'unsplash'
gem 'canonical-rails', github: 'jumph4x/canonical-rails'
gem 'wicked_pdf'
gem 'barby', '~> 0.6.2'
gem 'chunky_png', '~> 1.3', '>= 1.3.5'
group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

gem 'time_ago_in_words'
gem 'cancancan', '~> 2.0'
gem 'will_paginate-bootstrap'
gem 'sprockets', '~>3.7.2'
gem 'babosa'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "letter_opener"
  gem 'colorize'
  gem 'annotate'

  gem 'capistrano',         require: false
  gem 'capistrano-rbenv', '~> 2.1', '>= 2.1.4'
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  gem 'sshkit-sudo' #used to make the terminal interactive i.e to get the sudo passwords
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
