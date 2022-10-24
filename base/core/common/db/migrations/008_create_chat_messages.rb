Sequel.migration do
  up do
    create_table(:chat_messages) do
      primary_key :id
      foreign_key :sender_id, :users
      foreign_key :recipient_id, :users
      String :uuid, null: false, index: true
      String :content, null: false, text: true
      Time :sent_at, null: false
      Time :read_at, null: true
      TrueClass :deleted, default: false
      Time :deleted_at, null: true
    end
  end

  down do
    drop_table(:chat_messages)
  end
end
