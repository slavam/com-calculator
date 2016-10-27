class Payment < ActiveRecord::Base
  belongs_to :account
  belongs_to :utility
  validates :amount, presence: true
  validates :tariff_value, presence: true
  validates :quantity, presence: true
end
