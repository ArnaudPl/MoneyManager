class User < ApplicationRecord
  has_secure_password

  has_many :accounts
  has_many :transactions
  validates :inscription_date, presence: true
  validates :username, presence:true, length: {minimum: 5}
  validates :password_digest, presence:true, length: {minimum: 5}
end
