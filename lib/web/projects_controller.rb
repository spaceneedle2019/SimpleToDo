# frozen_string_literal: true

require_relative 'base_controller'
require_relative '../models/project'
require_relative '../services/project_creator'
require_relative '../services/project_updater'
require_relative '../services/project_deleter'
require_relative 'projects_serializer'
require_relative 'project_serializer'

class ProjectsController < BaseController
  get '/' do
    ProjectsSerializer.new(Project.all).call
  end

  get '/:projectId' do
    project = Project.find_by_id(project_id)
    not_found unless project

    ProjectSerializer.new(project).call
  end

  post '/' do
    project =
      ProjectCreator.new(
        name: body_params[:name],
        color: body_params[:color]
      ).call
    halt(422, serialize(project.errors)) unless project.errors.empty?

    status 201
    ProjectSerializer.new(project).call
  end

  patch '/:projectId' do
    project = ProjectUpdater.new(
      id: project_id,
      name: body_params[:name],
      color: body_params[:color]
    ).call
    not_found unless project
    halt(422, serialize(project.errors)) unless project.errors.empty?

    ProjectSerializer.new(project).call
  end

  delete '/:projectId' do
    ProjectDeleter.new(project_id).call
    status 204
  end
end
