# frozen_string_literal: true

require_relative '../../lib/web/items_serializer'

RSpec.describe ItemsSerializer do
  let(:items) do
    [create(:item)]
  end

  subject(:serializer) { described_class.new(items) }

  it 'returns JSON serialized items' do
    expected_object = {
      data: [
        {
          id: items.first.id,
          name: 't-shirt',
          checked: false,
          dueDate: nil,
          priority: nil
        }
      ]
    }

    expect(serializer.call).to eql(Oj.dump(expected_object))
  end

  context 'when due date is set' do
    let!(:items) { [create(:item, due_date:)] }
    let(:due_date) { Date.parse('2023-05-23') }

    it 'return a due date' do
      expect(Oj.load(serializer.call)[:data][0][:dueDate]).to eql(due_date.to_s)
    end
  end

  context 'when no items found' do
    let(:items) { [] }

    it 'returns empty data array' do
      expect(serializer.call).to eql(Oj.dump(data: []))
    end
  end
end
