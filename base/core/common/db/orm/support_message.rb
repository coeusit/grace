require 'securerandom'
class SupportMessage < Sequel::Model
  many_to_one :user, class: :User
  def before_create
    self.uuid = SecureRandom.uuid
    self.sent_at = Time.new
  end
end
