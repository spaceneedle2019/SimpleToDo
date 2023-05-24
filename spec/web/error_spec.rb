# frozen_string_literal: true

require_relative '../../lib/web/error'

RSpec.describe Error do
  describe '.not_found' do
    it 'returns a not found error' do
      expect(described_class.not_found)
        .to have_attributes(status: '404', title: 'not_found')
    end
  end

  describe '.internal_server_error' do
    it 'returns an internal server error' do
      expect(described_class.internal_server_error)
        .to have_attributes(status: '500', title: 'internal_server_error')
    end
  end

  describe '.unprocessable_entity' do
    it 'returns a unprocessable entity error' do
      expect(described_class.unprocessable_entity('blubber'))
        .to have_attributes(status: '422', title: 'unprocessable_entity',
                            detail: 'blubber')
    end
  end
end
