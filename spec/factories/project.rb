# frozen_string_literal: true

require_relative '../../lib/models/project'

FactoryBot.define do
  to_create(&:save)

  factory Project do
    name { 'vacation' }
    color { '#333333' }
  end
end
