Sequel.migration do
  up do
    create_table(:languages) do
      primary_key :id
      String :name, null: false
      TrueClass :is_fallback, null: false
      String :code, null: false, index: true
    end
  end

  down do
    drop_table(:languages)
  end
end
