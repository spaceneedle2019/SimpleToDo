# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:items) do
      primary_key :id
      foreign_key :project_id, :projects, null: false
      String :name, null: false
      Boolean :checked, null: false, default: false
      Integer :priority
      Date :due_date
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index :checked
      index %i[id project_id]
    end
  end
end
