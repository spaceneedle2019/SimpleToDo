# frozen_string_literal: true

require_relative '../../../lib/services/item_creator'

RSpec.describe ItemCreator do
  subject(:creator) do
    described_class.new(project_id:, name:, priority:, due_date:)
  end

  let(:project) { create(:project) }

  let(:project_id) { project.id }
  let(:name) { 'vacation' }
  let(:priority) { 1 }
  let(:due_date) { '2023-05-23' }

  it 'creates an item for a project' do
    result = creator.call
    expect(result.errors).to be_empty
    expect(result.valid?).to be(true)
    expect(Item.all.last).to have_attributes(
      project_id:,
      name:,
      priority:,
      due_date: Date.parse(due_date)
    )
  end

  context 'when project id is not present' do
    let(:project_id) { nil }

    it 'returns nil' do
      expect(creator.call).to be_nil
    end
  end

  context 'when name is present' do
    let(:name) { nil }

    it 'does not create an item' do
      creator.call
      expect(Item.all).to be_empty
    end

    it 'returns error' do
      result = creator.call
      expect(result.errors[:name]).to include('is not present')
      expect(result.valid?).to be(false)
    end
  end

  context 'when priority is not present' do
    let(:priority) { nil }

    it 'creates an item without priority' do
      result = creator.call
      expect(result.errors).to be_empty
      expect(result.valid?).to be(true)
      expect(Item.all.last).to have_attributes(
        project_id:,
        priority:
      )
    end
  end

  context 'when priority is not included in range' do
    let(:priority) { 5 }

    it 'does not create an item' do
      creator.call
      expect(Item.all).to be_empty
    end

    it 'returns error' do
      result = creator.call
      expect(result.errors[:priority])
        .to include('is not in range or set: [1, 2, 3]')
      expect(result.valid?).to be(false)
    end
  end
end
