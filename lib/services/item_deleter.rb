# frozen_string_literal: true

require_relative '../models/item'

class ItemDeleter
  def initialize(id:, project_id:)
    @id = id
    @project_id = project_id
  end

  def call
    Item.find_by(id:, project_id:)&.delete
  end

  private

  attr_reader :id, :project_id
end
