# frozen_string_literal: true

require_relative '../../lib/web/error'
require_relative '../../lib/web/errors_serializer'

RSpec.describe ErrorsSerializer do
  subject(:serializer) { described_class.new(Error.not_found) }

  it 'returns JSON serialized error' do
    expected_object = {
      errors: [
        {
          status: '404',
          title: 'not_found'
        }
      ]
    }

    expect(serializer.call).to eql(Oj.dump(expected_object))
  end
end
