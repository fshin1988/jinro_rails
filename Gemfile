source 'https://rubygems.org'
ruby '2.5.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'dotenv-rails', groups: [:development, :test]
gem 'rails', '5.2.0'
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
gem 'devise'
gem 'webpacker', '~> 3.0'
gem 'config'
gem 'pundit'
gem 'active_model_serializers', '~> 0.10.0'
gem 'kaminari'
gem 'sidekiq'
gem 'redis', '~> 3.0'
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

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'awesome_print'
  gem 'bullet'
  gem 'factory_bot_rails'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'rubocop', require: false
end

group :test do
  gem 'database_cleaner'
  gem 'shoulda-matchers'
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
  gem 'derailed_benchmarks'
end

group :production do
  gem 'google-analytics-rails'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
