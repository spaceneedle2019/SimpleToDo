# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'database_cleaner-sequel'
require 'factory_bot'
require 'simplecov'
require 'rack/test'
require 'webmock/rspec'
require_relative '../config/initializer'

SimpleCov.start do
  enable_coverage :branch
  primary_coverage :branch
end
SimpleCov.minimum_coverage(line: 100, branch: 100)

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around { |example| DatabaseCleaner.cleaning { example.run } }

  config.expect_with(:rspec) do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with(:rspec) do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.order = :random
  config.include Rack::Test::Methods
  config.disable_monkey_patching!
end
