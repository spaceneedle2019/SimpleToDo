# frozen_string_literal: true

class ProjectSerializer
  def initialize(project)
    @project = project
  end

  def call
    Oj.dump(data: { id: project.id, name: project.name, color: project.color })
  end

  private

  attr_reader :project
end
