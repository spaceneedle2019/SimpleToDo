# frozen_string_literal: true

require_relative 'base_controller'
require_relative '../models/item'
require_relative '../services/item_creator'
require_relative '../services/item_updater'
require_relative '../services/item_deleter'
require_relative 'items_serializer'
require_relative 'item_serializer'

class ItemsController < BaseController
  get '/:projectId/items' do
    ItemsSerializer.new(Item.all_by_project_id(project_id)).call
  end

  get '/:projectId/items/:itemId' do
    item = Item.find_by(id: item_id, project_id:)
    not_found unless item

    ItemSerializer.new(item).call
  end

  post '/:projectId/items' do
    item = ItemCreator.new(
      project_id:,
      name: body_params[:name],
      due_date: body_params[:dueDate],
      priority: body_params[:priority]
    ).call
    not_found unless item
    halt(422, serialize(item.errors)) unless item.errors.empty?

    status 201
    ItemSerializer.new(item).call
  end

  patch '/:projectId/items/:itemId' do
    item = ItemUpdater.new(
      id: item_id,
      project_id:,
      name: body_params[:name],
      due_date: body_params[:dueDate],
      priority: body_params[:priority]
    ).call
    not_found unless item
    halt(422, serialize(item.errors)) unless item.errors.empty?

    ItemSerializer.new(item).call
  end

  patch '/:projectId/items/:itemId/check' do
    Item.check(id: item_id, project_id:)
    status 200
  end

  patch '/:projectId/items/:itemId/uncheck' do
    Item.check(id: item_id, project_id:, check: false)
    status 200
  end

  delete '/:projectId/items/:itemId' do
    ItemDeleter.new(id: item_id, project_id:).call
    status 204
  end

  private

  def item_id
    params[:itemId]
  end
end
