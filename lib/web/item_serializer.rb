# frozen_string_literal: true

class ItemSerializer
  def initialize(item)
    @item = item
  end

  def call
    Oj.dump(
      data: {
        id: item.id,
        name: item.name,
        checked: item.checked,
        dueDate: item.due_date&.to_s,
        priority: item.priority
      }
    )
  end

  private

  attr_reader :item
end
