Sequel.migration do
  up do
    create_table(:cities) do
      primary_key :id
      foreign_key :region_id, :regions
      String :name, null: false
    end
  end

  down do
    drop_table(:cities)
  end
end
