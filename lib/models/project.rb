# frozen_string_literal: true

require 'sequel'

class Project < Sequel::Model
  one_to_many :items

  def validate
    validates_presence %i[name color]
    validates_unique :name
    validates_exact_length 7, :color
    validates_format(/^#?([0-9a-f]{6})$/, :color)
  end

  def self.find_by_id(id)
    find(id:)
  end
end
