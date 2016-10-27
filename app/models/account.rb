class Account < ActiveRecord::Base
  belongs_to :flat
  has_many :payments, :dependent => :destroy
  validates :start_date, presence: true
  validates :stop_date, presence: true
  validates :total, presence: true
end
