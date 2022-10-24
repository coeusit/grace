require 'date'
require 'openssl'
require 'securerandom'

def salted_hash(input)
  _salt = ENV['PWD_SALT']
  _hash = OpenSSL::Digest::SHA512.hexdigest(input)
  _salt_u = _salt.unpack("C*")
  _hash_u = _hash.unpack("C*")
  return _hash_u.zip(_salt_u).map{ |a,b| a^b }.pack("C*")
end

class User < Sequel::Model
  many_to_one :country
  many_to_one :organization
  many_to_one :city
  many_to_one :language
  one_to_many :sent_messages, class: :ChatMessage, key: :sender_id
  one_to_many :received_messages, class: :ChatMessage, key: :recipient_id
  one_to_many :support_messages, key: :user_id
  def authenticate(_pwd)
    _salted = salted_hash(_pwd)
    if self.password_digest == _salted
      return true
    else
      return false
    end
  end
  def password=(_password)
    self.password_digest = salted_hash(_password)
  end
  def before_create
    self.uuid = SecureRandom.uuid
  end
end
