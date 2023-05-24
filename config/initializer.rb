# frozen_string_literal: true

require 'dotenv'
require 'oj'
require 'sequel'

Dotenv.load(".env.#{ENV.fetch('RACK_ENV')}")

Oj.default_options = { mode: :strict, symbol_keys: true, empty_string: false }

Sequel.default_timezone = :utc
Sequel::Model.plugin :timestamps, update_on_create: true
Sequel::Model.plugin :forbid_lazy_load
Sequel::Model.plugin :validation_helpers

DB = Sequel.connect(ENV.fetch('POSTGRES_URL'), max_connections: 5)
# logger: Logger.new('db.log')
