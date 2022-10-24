class Country < Sequel::Model
  one_to_many :organizations
  one_to_many :users
  one_to_many :regions
end
