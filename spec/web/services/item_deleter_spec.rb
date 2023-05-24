# frozen_string_literal: true

require_relative '../../../lib/services/item_deleter'

RSpec.describe ItemDeleter do
  subject(:deleter) { described_class.new(id:, project_id:) }

  let!(:item) { create(:item) }
  let(:id) { item.id }
  let(:project_id) { item.project.id }

  it 'deletes a project' do
    expect(deleter.call).to eql(item)
    expect(Item.all).to be_empty
  end

  context 'when no item found' do
    let(:id) { 666 }

    it 'does not delete a project' do
      expect(deleter.call).to be_nil
      expect(Item.all).not_to be_empty
    end
  end
end
