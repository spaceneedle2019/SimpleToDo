# frozen_string_literal: true

require_relative '../../lib/web/projects_serializer'

RSpec.describe ProjectsSerializer do
  let(:projects) do
    [create(:project)]
  end

  subject(:serializer) { described_class.new(projects) }

  it 'returns JSON serialized projects' do
    expected_object = {
      data: [
        {
          id: projects.first.id,
          name: 'vacation',
          color: '#333333'
        }
      ]
    }

    expect(serializer.call).to eql(Oj.dump(expected_object))
  end

  context 'when no projects found' do
    let(:projects) { [] }

    it 'returns empty data array' do
      expect(serializer.call).to eql(Oj.dump(data: []))
    end
  end
end
