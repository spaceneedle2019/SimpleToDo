# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:projects) do
      primary_key :id
      String :name, null: false
      String :color, null: false
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index :name, unique: true
    end
  end
end
