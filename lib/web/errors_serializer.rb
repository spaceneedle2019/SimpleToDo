# frozen_string_literal: true

class ErrorsSerializer
  def initialize(error)
    @error = error
  end

  def call
    Oj.dump(
      {
        errors: [
          { status: error.status, title: error.title, detail: error.detail }
            .compact
        ]
      }
    )
  end

  private

  attr_reader :error
end
