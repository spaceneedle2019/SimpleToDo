# frozen_string_literal: true

require_relative '../../lib/web/project_serializer'

RSpec.describe ProjectSerializer do
  let(:project) do
    create(:project)
  end

  subject(:serializer) { described_class.new(project) }

  it 'returns JSON serialized project' do
    expected_object = {
      data:
        {
          id: project.id,
          name: 'vacation',
          color: '#333333'
        }
    }

    expect(serializer.call).to eql(Oj.dump(expected_object))
  end
end
