# frozen_string_literal: true

require_relative '../../../lib/web/simple_to_do'

RSpec.describe 'ItemsRequest' do
  let(:app) { SimpleToDo }
  let!(:item) { create(:item) }

  before { header 'Content-Type', 'application/json' }

  describe 'GET /projects/:projectId/items' do
    it 'returns items' do
      get("/projects/#{item.project.id}/items")
      expect(Oj.load(last_response.body)).to eql(
        {
          data: [
            {
              id: item.id,
              name: item.name,
              checked: false,
              priority: nil,
              dueDate: nil
            }
          ]
        }
      )
    end

    context 'when project id is invalid' do
      it 'returns status 400' do
        get('/projects/invalidId/items')

        expect(last_response.status).to be(400)
      end
    end
  end

  describe 'GET /projects/:projectId/items/:itemId' do
    it 'returns a single item' do
      get("/projects/#{item.project.id}/items/#{item.id}")

      expect(Oj.load(last_response.body)).to eql(
        {
          data: {
            id: item.id,
            name: item.name,
            checked: false,
            priority: nil,
            dueDate: nil
          }
        }
      )
    end

    context 'when item id was not found' do
      it 'returns status 404' do
        get("/projects/#{item.project.id}/items/666")

        expect(last_response.status).to be(404)
      end
    end

    context 'when item id is invalid' do
      it 'returns status 400' do
        get('/projects/23/items/invalidId')

        expect(last_response.status).to be(400)
      end
    end

    context 'when project id is invalid' do
      it 'returns status 400' do
        get('/projects/invalidId/items/42')

        expect(last_response.status).to be(400)
      end
    end
  end

  describe 'POST /projects/:projectId/items' do
    let(:project) { create(:project, name: 'orders') }
    let(:request_body) { { data: { name: 't-shirt' } } }

    context 'when successful' do
      before { post("/projects/#{project.id}/items", Oj.dump(request_body)) }

      it 'returns a created item for a project' do
        last_item = Item.all.last
        expected_response =
          {
            data: {
              id: last_item.id,
              name: last_item.name,
              checked: false,
              priority: nil,
              dueDate: nil
            }
          }

        expect(Oj.load(last_response.body)).to eql(expected_response)
      end

      it 'returns status 201' do
        expect(last_response.status).to be(201)
      end
    end

    context 'when project was not found' do
      before { post('/projects/666/items', Oj.dump(request_body)) }

      it 'returns status 422' do
        expect(last_response.status).to be(404)
      end
    end

    context 'when validation fails' do
      before { post("/projects/#{project.id}/items", Oj.dump(request_body)) }

      let(:request_body) { { data: { name: 't-shirt', priority: 5 } } }
      let(:expected_error) do
        {
          errors:
            [
              status: '422',
              title: 'unprocessable_entity',
              detail: { priority: ['is not in range or set: [1, 2, 3]'] }
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

  describe 'PATCH /projects/:projectId/items/:itemId' do
    let(:item_id) { item.id }
    let(:priority) { 2 }

    let(:request_body) do
      { data: { name: 'shorts', dueDate: '2023-02-01', priority: } }
    end

    before do
      patch(
        "/projects/#{item.project.id}/items/#{item_id}", Oj.dump(request_body)
      )
    end

    it 'returns an updated item' do
      expected_response =
        {
          data: {
            id: item_id,
            name: 'shorts',
            checked: false,
            dueDate: '2023-02-01',
            priority: 2
          }
        }

      expect(Oj.load(last_response.body)).to eql(expected_response)
    end

    context 'when item was not found' do
      let(:item_id) { 666 }
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
      let(:priority) { 7 }
      let(:expected_error) do
        {
          errors:
            [
              status: '422',
              title: 'unprocessable_entity',
              detail: { priority: ['is not in range or set: [1, 2, 3]'] }
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

  describe 'PATCH /projects/:projectId/items/:itemId/check' do
    before { patch("/projects/#{item.project.id}/items/#{item_id}/check") }
    let(:item_id) { item.id }

    it 'returns status 200' do
      expect(last_response.status).to be(200)
    end

    context 'when item not found' do
      let(:item_id) { 666 }

      it 'returns status 200' do
        expect(last_response.status).to be(200)
      end
    end
  end

  describe 'PATCH /projects/:projectId/items/:itemId/uncheck' do
    before { patch("/projects/#{item.project.id}/items/#{item_id}/uncheck") }
    let(:item_id) { item.id }

    it 'returns status 200' do
      expect(last_response.status).to be(200)
    end

    context 'when item not found' do
      let(:item_id) { 666 }

      it 'returns status 200' do
        expect(last_response.status).to be(200)
      end
    end
  end

  describe 'DELETE /projects/:projectId/items/:itemId' do
    it 'returns status 204' do
      delete("/projects/#{item.project.id}/items/#{item.id}")

      expect(last_response.status).to be(204)
    end
  end
end
