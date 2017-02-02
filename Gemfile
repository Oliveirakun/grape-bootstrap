source 'https://rubygems.org'
ruby '2.3.0'

gem 'rack', '~> 2.0.1'
gem 'grape', '~> 0.17.0'
gem 'grape-entity', '~> 0.5.1'
gem 'grape-swagger', '~> 0.25.0'
gem 'mysql2', '~> 0.4.4'
gem 'activerecord', '~> 4.2.7', require: 'active_record'
gem 'require_all', '~> 1.3.3'

group :development, :test do
  gem 'pry-byebug'
end

group :development do
  gem 'rake'
  gem 'thin'
end

group :test do
  gem 'rspec'
  gem 'rack-test'
  gem 'factory_girl'
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  gem 'simplecov', require: false
end

