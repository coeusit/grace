Sequel.migration do
  up do
    create_table(:email_templates) do
      primary_key :id
      String :name, null: false, index: true
      String :sender_address, null: false
      String :subject, null: false
      String :content_html, null: false, text: true
      String :content_plain, null: false, text: true
    end
  end

  down do
    drop_table(:email_templates)
  end
end
