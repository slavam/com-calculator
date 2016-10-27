class Flat < ActiveRecord::Base
  has_many :accounts
  has_many :utilities
  before_save :default_values
  validates :address, presence: true, uniqueness: true
  validates :total_area, presence: true
  
  def payer_fullname
    self.payer_lastname+' '+self.payer_firstname+' '+self.payer_middlename
  end
  
  def payer_shortname
    self.payer_lastname+' '+(self.payer_firstname>'' ? self.payer_firstname[0,1]+'.'+
    (self.payer_middlename>'' ? self.payer_middlename[0,1]+'.' : '') : '')
  end
  
  private
    def default_values
      self.heated_area ||= 0
      self.residents_number ||= 0
    end
end
