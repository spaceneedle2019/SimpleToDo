# frozen_string_literal: true

require_relative '../../../lib/web/simple_to_do'

RSpec.describe 'ProjectsRequest' do
  let(:app) { SimpleToDo }
  let!(:project) { create(:project) }

  before { header 'Content-Type', 'application/json' }

  describe 'GET /projects' do
    it 'returns projects' do
      get('/projects')

      expect(Oj.load(last_response.body)).to eql(
        {
          data: [
            { id: project.id, name: project.name, color: project.color }
          ]
        }
      )
    end
  end

  describe 'GET /projects/:projectId' do
    it 'returns a single project' do
      get("/projects/#{project.id}")

      expect(Oj.load(last_response.body)).to eql(
        { data: { id: project.id, name: 'vacation', color: '#333333' } }
      )
    end

    context 'when project id is invalid' do
      it 'returns status 400' do
        get('/projects/invalidId')

        expect(last_response.status).to be(400)
      end
    end

    context 'when project id was not found' do
      it 'returns status 404' do
        get('/projects/666')

        expect(last_response.status).to be(404)
      end
    end
  end

  describe 'POST /projects' do
    let(:project) { create(:project, name: 'orders') }
    let(:color) { '#555555' }
    let(:request_body) do
      { data: { name: 'vacation', color: } }
    end

    before do
      post('/projects', Oj.dump(request_body))
    end

    it 'returns a created project' do
      last_project = Project.all.last
      expected_response =
        { data: { id: last_project.id, name: 'vacation', color: '#555555' } }

      expect(Oj.load(last_response.body)).to eql(expected_response)
    end

    it 'returns status 201' do
      expect(last_response.status).to be(201)
    end

    context 'when validation fails' do
      let(:color) { 'blubberblubb' }
      let(:expected_error) do
        {
          errors:
            [
              status: '422',
              title: 'unprocessable_entity',
              detail: { color: ['is not 7 characters', 'is invalid'] }
            ]
        }
      end

      it 'returns validation error' do
        expect(Oj.load(last_response.body)).to eql(expected_error)
      end

      it 'returns status 422' do
        expect(last_response.status).to be(422)
      end
    end
  end

  describe 'PATCH /projects/:projectId' do
    let(:id) { project.id }
    let(:color) { '#555555' }
    let(:request_body) do
      { data: { name: 'vacation', color: } }
    end

    before do
      patch("/projects/#{id}", Oj.dump(request_body))
    end

    it 'returns an updated project' do
      expected_response =
        { data: { id: project.id, name: 'vacation', color: '#555555' } }

      expect(Oj.load(last_response.body)).to eql(expected_response)
    end

    context 'when project not found' do
      let(:id) { 666 }
      let(:expected_error) do
        { errors: [status: '404', title: 'not_found'] }
      end

      it 'returns validation error' do
        expect(Oj.load(last_response.body)).to eql(expected_error)
      end

      it 'returns status 404' do
        expect(last_response.status).to be(404)
      end
    end

    context 'when validation fails' do
      let(:color) { 'blubberblubb' }
      let(:expected_error) do
        {
          errors:
            [
              status: '422',
              title: 'unprocessable_entity',
              detail: { color: ['is not 7 characters', 'is invalid'] }
            ]
        }
      end

      it 'returns validation error' do
        expect(Oj.load(last_response.body)).to eql(expected_error)
      end

      it 'returns status 422' do
        expect(last_response.status).to be(422)
      end
    end
  end

  describe 'DELETE /projects/:projectId' do
    it 'returns status 204' do
      delete("/projects/#{project.id}")

      expect(last_response.status).to be(204)
    end
  end
end
