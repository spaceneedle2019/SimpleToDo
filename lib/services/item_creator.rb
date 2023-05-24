# frozen_string_literal: true

require_relative '../models/item'

class ItemCreator
  def initialize(project_id:, name:, priority:, due_date:)
    @project_id = project_id
    @name = name
    @priority = priority
    @due_date = due_date
  end

  def call
    project = Project.find_by_id(project_id)
    return unless project

    item = Item.new(project:, name:, priority:, due_date:)
    item.valid? ? item.save : item
  end

  private

  attr_reader :project_id, :name, :priority, :due_date
end
