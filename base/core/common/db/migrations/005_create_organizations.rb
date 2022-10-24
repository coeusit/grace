Sequel.migration do
  up do
    create_table(:organizations) do
      primary_key :id
      foreign_key :country_id, :countries, null: true
      foreign_key :language_id, :languages, null: true
      String :uuid, null: false, index: true
      String :name, null: false
      String :maintenance_email, null: true
      TrueClass :enabled, null: false
    end
  end

  down do
    drop_table(:organizations)
  end
end
