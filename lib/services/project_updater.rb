# frozen_string_literal: true

require_relative '../models/project'

class ProjectUpdater
  def initialize(id:, name:, color:)
    @id = id
    @name = name
    @color = color
  end

  def call
    project = Project.find_by_id(id)
    return unless project

    project.set({ name:, color: }.compact)
    project.valid? ? project.save : project
  end

  private

  attr_reader :id, :name, :color
end
