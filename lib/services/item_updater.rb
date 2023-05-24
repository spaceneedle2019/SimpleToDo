# frozen_string_literal: true

require_relative '../models/item'

class ItemUpdater
  def initialize(id:, project_id:, name:, due_date:, priority:)
    @id = id
    @project_id = project_id
    @name = name
    @due_date = due_date
    @priority = priority
  end

  def call
    item = Item.find_by(id:, project_id:)
    return unless item

    item.set({ name:, due_date:, priority: }.compact)
    item.valid? ? item.save : item
  end

  private

  attr_reader :id, :project_id, :name, :due_date, :priority
end
