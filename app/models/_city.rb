class City < ActiveRecord::Base
  establish_connection :residents
  self.abstract_class = true
end
