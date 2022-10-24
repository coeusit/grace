Sequel.migration do
  up do
    create_table(:page_components) do
      primary_key :id
      foreign_key :page_id, :pages
      String :uuid, null: false, index: true
      String :parameters, null: true, text: true
      Fixnum :sorted_order, null: false
    end
  end

  down do
    drop_table(:page_components)
  end
end
