# frozen_string_literal: true

require 'sinatra/base'
require_relative '../../config/initializer'
require_relative 'projects_controller'
require_relative 'items_controller'

SimpleToDo = Rack::Builder.new do
  map '/projects' do
    run Rack::Cascade.new([ProjectsController, ItemsController])
  end
end
