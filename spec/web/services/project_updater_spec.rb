# frozen_string_literal: true

require_relative '../../../lib/services/project_updater'

RSpec.describe ProjectUpdater do
  subject(:updater) { described_class.new(id:, name:, color:) }

  let(:project) { create(:project) }
  let(:id) { project.id }
  let(:name) { 'vacation' }
  let(:color) { '#333333' }

  it 'updates a project' do
    result = updater.call
    expect(result.errors).to be_empty
    expect(result.valid?).to be(true)
    expect(Project.find(id:)).to have_attributes(name:, color:)
  end

  context 'when project was not found' do
    let(:id) { 666 }

    it 'returns nil' do
      expect(updater.call).to be_nil
    end
  end

  context 'when attributes are nil' do
    let(:name) { nil }
    let(:color) { nil }

    it 'does not update the project' do
      updater.call
      expect(Project.find(id:)).to have_attributes(
        name: 'vacation', color: '#333333'
      )
    end
  end

  context 'when color is not matching length' do
    let(:color) { 'xyz' }

    it 'returns error' do
      result = updater.call
      expect(result.errors[:color]).to include('is not 7 characters')
      expect(result.valid?).to be(false)
    end
  end

  context 'when color is not matching color hex code' do
    let(:color) { '#xyz234' }

    it 'returns error' do
      result = updater.call
      expect(result.errors[:color]).to include('is invalid')
      expect(result.valid?).to be(false)
    end
  end

  context 'when name is not unique' do
    before { create(:project) }
    let(:project) { create(:project, name: 'shopping list') }

    it 'returns error' do
      result = updater.call
      expect(result.errors).not_to be_empty
      expect(result.valid?).to be(false)
    end
  end
end
