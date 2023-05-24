# frozen_string_literal: true

$stdout.sync = $stderr.sync = true

map '/health' do
  run lambda { |_env|
        [200, { 'Content-Type' => 'application/json' }, %w[{"health": "good"}]]
      }
end

require_relative 'lib/web/simple_to_do'
run SimpleToDo
