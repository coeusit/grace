Sequel.migration do
  up do
    create_table(:menu_items) do
      primary_key :id
      foreign_key :parent_id, :menu_items, null: true
      String :uuid, null: false, index: true
      String :uri, null: false, index: true
      String :caption, null: false
      String :subtitle, null: true
      String :icon, null: true
      Fixnum :sorted_order, null: false
      TrueClass :public, null: false
    end
  end

  down do
    drop_table(:menu_items)
  end
end
