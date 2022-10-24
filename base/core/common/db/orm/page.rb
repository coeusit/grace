require 'securerandom'
class Page < Sequel::Model
  one_to_many :page_components
  def before_create
    self.uuid = SecureRandom.uuid
  end
  def before_destroy
    self.page_components.each do |c|
      c.destroy
    end
  end
end
