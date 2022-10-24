class Language < Sequel::Model
  one_to_many :users
  one_to_many :organizations
end
