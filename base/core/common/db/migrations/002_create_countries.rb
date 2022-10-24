Sequel.migration do
  up do
    create_table(:countries) do
      primary_key :id
      foreign_key :language_id, :languages
      String :name, null: false
      String :code, null: false, index: true
    end
  end

  down do
    drop_table(:countries)
  end
end
