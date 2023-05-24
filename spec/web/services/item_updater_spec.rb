# frozen_string_literal: true

require_relative '../../../lib/services/item_updater'

RSpec.describe ItemUpdater do
  subject(:updater) do
    described_class.new(id:, project_id:, name:, due_date:, priority:)
  end

  let(:item) { create(:item) }
  let(:id) { item.id }
  let(:project_id) { item.project.id }
  let(:name) { 'shorts' }
  let(:due_date) { '2023-02-01' }
  let(:priority) { 3 }

  it 'updates an item' do
    result = updater.call
    expect(result.errors).to be_empty
    expect(result.valid?).to be(true)
    expect(Item.find(id:)).to have_attributes(
      name:,
      due_date: Date.parse(due_date),
      priority:
    )
  end

  context 'when item was not found' do
    let(:id) { 666 }

    it 'returns nil' do
      expect(updater.call).to be_nil
    end
  end

  context 'when attributes are nil' do
    let(:name) { nil }
    let(:due_date) { nil }
    let(:priority) { nil }

    it 'does not update the item' do
      updater.call
      expect(Item.find(id:)).to have_attributes(
        name: 't-shirt', due_date: nil, priority: nil
      )
    end
  end

  context 'when priority is not included in range' do
    let(:priority) { 5 }

    it 'returns error' do
      result = updater.call
      expect(result.errors[:priority])
        .to include('is not in range or set: [1, 2, 3]')
      expect(result.valid?).to be(false)
    end
  end
end
