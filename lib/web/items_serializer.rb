# frozen_string_literal: true

class ItemsSerializer
  def initialize(items)
    @items = items
  end

  def call
    Oj.dump(
      data:
        items.map do |item|
          {
            id: item.id,
            name: item.name,
            checked: item.checked,
            dueDate: item.due_date&.to_s,
            priority: item.priority
          }
        end
    )
  end

  private

  attr_reader :items
end
