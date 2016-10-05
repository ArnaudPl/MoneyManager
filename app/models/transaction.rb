class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :account

  validates :withdraw, presence: true
  validates :amount, presence: true, :numericality => {:greater_than_or_equal_to => 0}
end
