# frozen_string_literal: true

require_relative '../../../lib/services/project_creator'

RSpec.describe ProjectCreator do
  subject(:creator) { described_class.new(name:, color:) }

  let(:name) { 'vacation' }
  let(:color) { '#333333' }

  it 'creates a project' do
    result = creator.call
    expect(result.errors).to be_empty
    expect(result.valid?).to be(true)
    expect(Project.all.last).to have_attributes(name:, color:)
  end

  context 'when color is not matching length' do
    let(:color) { 'xyz' }

    it 'does not create a project' do
      creator.call
      expect(Project.all).to be_empty
    end

    it 'returns error' do
      result = creator.call
      expect(result.errors[:color]).to include('is not 7 characters')
      expect(result.valid?).to be(false)
    end
  end

  context 'when color is not matching color hex code' do
    let(:color) { '#xyz234' }

    it 'does not create a project' do
      creator.call
      expect(Project.all).to be_empty
    end

    it 'returns error' do
      result = creator.call
      expect(result.errors[:color]).to include('is invalid')
      expect(result.valid?).to be(false)
    end
  end

  context 'when name is not unique' do
    before { create(:project) }

    it 'returns error' do
      result = creator.call
      expect(result.errors).not_to be_empty
      expect(result.valid?).to be(false)
    end
  end
end
