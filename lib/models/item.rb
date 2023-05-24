# frozen_string_literal: true

require 'sequel'

class Item < Sequel::Model
  many_to_one :project

  def validate
    validates_presence %i[project_id name]
    validates_includes [1, 2, 3], :priority, allow_nil: true
  end

  def self.all_by_project_id(project_id)
    where(project_id:)
  end

  def self.find_by(id:, project_id:)
    find(id:, project_id:)
  end

  def self.check(id:, project_id:, check: true)
    find_by(id:, project_id:)&.update(checked: check)
  end
end
