# frozen_string_literal: true

require_relative 'error'
require_relative 'errors_serializer'

class ValidationError < Committee::ValidationError
  def render
    [
      status, { 'Content-Type' => 'application/json' },
      [ErrorsSerializer.new(
        Error.new(title: id, status:, detail: message)
      ).call]
    ]
  end
end
