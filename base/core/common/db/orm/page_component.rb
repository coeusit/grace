require 'securerandom'
class PageComponent < Sequel::Model
  many_to_one :page
  def before_create
    self.uuid = SecureRandom.uuid
  end
end
