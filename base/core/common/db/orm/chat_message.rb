require 'securerandom'
class ChatMessage < Sequel::Model
  many_to_one :sender, class: :User
  many_to_one :recipient, class: :User
  def before_create
    self.uuid = SecureRandom.uuid
  end
end
