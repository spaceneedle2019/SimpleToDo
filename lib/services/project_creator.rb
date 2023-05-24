# frozen_string_literal: true

require_relative '../models/project'

class ProjectCreator
  def initialize(name:, color:)
    @name = name
    @color = color
  end

  def call
    project = Project.new(name:, color:)
    project.valid? ? project.save : project
  end

  private

  attr_reader :name, :color
end
