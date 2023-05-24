# frozen_string_literal: true

require 'sequel'
require 'dotenv'

Dotenv.load(".env.#{ENV.fetch('RACK_ENV', 'development')}")

def postgres_url
  ENV.fetch('POSTGRES_URL')
end

def database
  ENV.fetch('POSTGRES_DB')
end

def select_database
  "SELECT 1 FROM pg_database WHERE datname='#{database}'"
end

def database_exists?(db)
  db.execute(select_database) == 1
end

namespace :db do
  desc 'Create database'
  task :create do
    Sequel.connect(File.dirname(postgres_url)) do |db|
      abort("Database #{database} already exists") if database_exists?(db)
      db.execute("CREATE DATABASE #{database}")
      puts "Database #{database} created"
    rescue Sequel::DatabaseError => e
      warn e.message
    end
  end

  desc 'Run database migrations'
  task :migrate, [:version] do |_, args|
    version = args[:version].to_i if args[:version]
    Sequel.connect(postgres_url) do |db|
      directory = 'db/migrations'
      if Dir.exist?(directory) && !Dir.empty?(directory)
        Sequel.extension(:migration)
        db.extension :pg_enum, :pg_range
        Sequel::Migrator.run(db, directory, target: version)
        puts "Database #{database} migrated"
      end
    end
  end

  desc 'Drop database'
  task :drop do
    Sequel.connect(File.dirname(postgres_url)) do |db|
      abort("Database #{database} not found") unless database_exists?(db)
      db.execute("DROP DATABASE #{database}")
      puts "Database #{database} dropped"
    end
  end
end
