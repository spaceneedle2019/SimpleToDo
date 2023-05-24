# frozen_string_literal: true

require_relative '../models/project'

class ProjectDeleter
  def initialize(id)
    @id = id
  end

  def call
    Project.find_by_id(id)&.delete
  end

  private

  attr_reader :id
end
