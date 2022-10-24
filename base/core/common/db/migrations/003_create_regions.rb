Sequel.migration do
  up do
    create_table(:regions) do
      primary_key :id
      foreign_key :country_id, :countries
      String :name, null: false
    end
  end

  down do
    drop_table(:regions)
  end
end
