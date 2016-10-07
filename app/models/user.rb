class User < ApplicationRecord
  has_secure_password

  has_many :accounts, dependent: :destroy
  has_many :transactions, dependent: :destroy
  validates :inscription_date, presence: true
  validates :username, presence: true, length: {minimum: 5}, uniqueness: true
  validates :password_digest, presence: true, length: {minimum: 5}
end
