Sequel.migration do
  up do
    create_table(:server_settings) do
      primary_key :id
      String :name, null: false, index: true
      String :content, null: false, text: true
    end
  end

  down do
    drop_table(:server_settings)
  end
end
