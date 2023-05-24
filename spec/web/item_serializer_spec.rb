# frozen_string_literal: true

require_relative '../../lib/web/item_serializer'

RSpec.describe ItemSerializer do
  let(:item) { create(:item) }

  subject(:serializer) { described_class.new(item) }

  it 'returns JSON serialized project' do
    expected_object = {
      data:
        {
          id: item.id,
          name: 't-shirt',
          checked: false,
          dueDate: nil,
          priority: nil
        }
    }

    expect(serializer.call).to eql(Oj.dump(expected_object))
  end

  context 'when due date is set' do
    let!(:item) { create(:item, due_date:) }
    let(:due_date) { Date.parse('2023-05-23') }

    it 'return a due date' do
      expect(Oj.load(serializer.call)[:data][:dueDate]).to eql(due_date.to_s)
    end
  end
end
