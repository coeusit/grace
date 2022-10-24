class City < Sequel::Model
  many_to_one :region
  one_to_many :users
end
