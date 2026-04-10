# frozen_string_literal: true

threads 0, 5

port ENV.fetch('PORT', 9292)

environment ENV.fetch('RACK_ENV', 'development')
