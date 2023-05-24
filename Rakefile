# frozen_string_literal: true

require 'rake'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'

task default: %i[spec rubocop api-doc:create]

RuboCop::RakeTask.new(:rubocop) do |task|
  task.formatters = ['simple']
  task.fail_on_error = true
end

RSpec::Core::RakeTask.new(:spec) do |task|
  task.with_clean_environment = 'test'
  task.pattern = 'spec/**/*_spec.rb'
  task.rspec_opts = '--format documentation'
end

desc 'Create API documentation'
task('api-doc:create') { system('npm run createApiDocumentation') }
