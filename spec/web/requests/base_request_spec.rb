# frozen_string_literal: true

require_relative '../../../lib/web/simple_to_do'

RSpec.describe 'BaseRequest' do
  let(:app) do
    Class.new(BaseController) do
      get('/broken') do
        raise
      end
    end.new!
  end

  before do
    header 'Context-Type', 'application/json'
  end

  it 'returns errors on status 500' do
    get('/broken')

    expected_response = {
      errors: [
        {
          status: '500',
          title: 'internal_server_error'
        }
      ]
    }

    expect(last_response.status).to be(500)
    expect(Oj.load(last_response.body)).to eql(expected_response)
  end

  it 'returns errors on status 404' do
    get('/not_found')

    expected_response = {
      errors: [
        {
          status: '404',
          title: 'not_found'
        }
      ]
    }

    expect(last_response.status).to be(404)
    expect(Oj.load(last_response.body)).to eql(expected_response)
  end
end
