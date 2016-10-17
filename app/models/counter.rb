class Counter < ActiveRecord::Base
  belongs_to :account
  belongs_to :utility
end
