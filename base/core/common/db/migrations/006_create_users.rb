Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id
      foreign_key :organization_id, :organizations, null: true
      foreign_key :country_id, :countries, null: true
      foreign_key :city_id, :cities, null: true
      foreign_key :language_id, :languages, null: true
      String :uuid, null: false, index: true
      String :email, null: false
      String :phone, null: true
      String :address_line_1, null: true
      String :address_line_2, null: true
      String :address_line_3, null: true
      String :first_name, null: true
      String :last_name, null: true
      String :company, null: true
      String :city_name, null: true
      String :region_name, null: true
      String :country_name, null: true
      String :avatar, null: true
      DateTime :last_online, null: true
      String :otp_secret, null: true
      Fixnum :last_otp_at, null: true
      String :password_digest, null: false
      String :verification, null: true
      TrueClass :enabled, null: false
      TrueClass :admin, null: false
    end
  end

  down do
    drop_table(:users)
  end
end
