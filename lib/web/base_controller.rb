# frozen_string_literal: true

require 'committee'
require_relative 'error'
require_relative 'errors_serializer'
require_relative 'validation_error'

class BaseController < Sinatra::Application
  set :dump_errors, !production?
  configure { mime_type :json, 'application/json' }

  before do
    content_type :json
    @req_body = request.body.size.positive? ? Oj.load(request.body) : nil
  end

  use Committee::Middleware::RequestValidation,
      schema_path: 'openapi/openapi.yml',
      error_class: ValidationError,
      strict_reference_validation: true,
      parse_response_by_content_type: false

  use Committee::Middleware::ResponseValidation,
      schema_path: 'openapi/openapi.yml',
      raise: !production?,
      error_class: ValidationError,
      strict_reference_validation: true,
      parse_response_by_content_type: false

  error(404) { ErrorsSerializer.new(Error.not_found).call }

  error(500) { ErrorsSerializer.new(Error.internal_server_error).call }

  private

  def project_id
    params[:projectId]
  end

  def body_params
    @body_params ||= @req_body.fetch(:data)
  end

  def serialize(errors)
    ErrorsSerializer.new(Error.unprocessable_entity(errors)).call
  end

  # error 404 definition is not correctly working with different controllers
  def not_found
    halt(404, ErrorsSerializer.new(Error.not_found).call)
  end
end
