ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start
require File.expand_path('../../config/environment', __FILE__)
require 'rspec'
require 'shoulda-matchers'
require 'factory_girl'
require 'database_cleaner'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.library :active_record
    with.test_framework :rspec
  end
end

RSpec.configure do |config|
  #Shoulda-Matchers
  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)

  #Factory Girl
  config.include(FactoryGirl::Syntax::Methods)
  config.before(:suite) do
    FactoryGirl.find_definitions
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

