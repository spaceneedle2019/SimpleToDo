# frozen_string_literal: true

require_relative '../../../lib/services/project_deleter'

RSpec.describe ProjectDeleter do
  subject(:deleter) { described_class.new(id) }

  let!(:project) { create(:project) }
  let(:id) { project.id }

  it 'deletes a project' do
    expect(deleter.call).to eql(project)
    expect(Project.all).to be_empty
  end

  context 'when no project found' do
    let(:id) { 666 }

    it 'does not delete a project' do
      expect(deleter.call).to be_nil
      expect(Project.all).not_to be_empty
    end
  end
end
