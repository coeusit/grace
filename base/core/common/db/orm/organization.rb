require 'securerandom'

class Organization < Sequel::Model
  many_to_one :country
  many_to_one :language
  one_to_many :users
  def before_create
    self.uuid = SecureRandom.uuid
  end
end
