# frozen_string_literal: true

require 'valued'

class Error
  include Valued

  attributes :status, :title, :detail

  def self.not_found
    new(status: '404', title: 'not_found')
  end

  def self.internal_server_error
    new(status: '500', title: 'internal_server_error')
  end

  def self.unprocessable_entity(message)
    new(status: '422', title: 'unprocessable_entity', detail: message)
  end
end
