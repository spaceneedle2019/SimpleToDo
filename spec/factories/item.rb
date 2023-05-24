# frozen_string_literal: true

require_relative '../../lib/models/item'
require_relative '../../lib/models/project'

FactoryBot.define do
  to_create(&:save)

  factory Item do
    name { 't-shirt' }
    project
  end
end
