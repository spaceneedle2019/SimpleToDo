# frozen_string_literal: true

class ProjectsSerializer
  def initialize(projects)
    @projects = projects
  end

  def call
    Oj.dump(
      data:
        projects.map do |project|
          { id: project.id, name: project.name, color: project.color }
        end
    )
  end

  private

  attr_reader :projects
end
