Sequel.migration do
  up do
    create_table(:pages) do
      primary_key :id
      String :uuid, null: false, index: true
      String :uri, null: false, index: true
      TrueClass :public, null: false
    end
  end

  down do
    drop_table(:pages)
  end
end
