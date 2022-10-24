require 'securerandom'
class MenuItem < Sequel::Model
  many_to_one :parent, class: self
  one_to_many :children, key: :parent_id, class: self
  def before_create
    self.uuid = SecureRandom.uuid
  end
  def before_destroy
    self.children.each do |c|
      c.destroy
    end
  end
end
