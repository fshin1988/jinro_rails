source 'https://rubygems.org'
ruby '3.0.7'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'dotenv-rails', groups: [:development, :test]
gem 'rails', '~> 6.1.7'
gem 'puma', '~> 3.0'
gem 'sass-rails'
gem 'bootstrap-sass'
gem 'font-awesome-rails'
gem 'slim-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'rails-i18n'
gem 'devise', '~> 4.7.0'
gem 'webpacker', '~> 3.0'
gem 'config', '~> 2.2.3'
gem 'pundit'
gem 'active_model_serializers', '~> 0.10.0'
gem 'kaminari', '~> 1.2.0'
gem 'sidekiq', '~> 6.5'
gem 'redis', '~> 4.0'
gem 'bootsnap'
gem 'mini_magick'
gem 'aws-sdk-s3'
gem 'redcarpet'
gem 'sitemap_generator'
gem 'pg'
gem 'scout_apm'
gem 'puma_worker_killer'
gem 'twitter'
gem 'activerecord-precounter'
gem 'loofah', '>= 2.2.3'
gem 'mimemagic', '0.3.8'
gem 'image_processing', '~> 1.12.0'
gem 'ffi', '< 1.17.0'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'awesome_print'
  gem 'bullet'
  gem 'factory_bot_rails', '~> 6.2.0'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'rspec-rails','~> 5.0.0'
  gem 'rubocop', require: false
end

group :test do
  gem 'database_cleaner'
  gem 'capybara'
  gem 'poltergeist'
  gem 'launchy'
  gem 'timecop'
  gem 'simplecov'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'annotate'
  gem 'better_errors'
  gem 'html2slim'
end

group :production do
  gem 'google-analytics-rails'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
