class Tariff < ActiveRecord::Base
  belongs_to :category
  validates :name, :value, :category_id, presence: true
  
  def self.tariff_by_volume category_id, volume
    tariff = self.where("category_id = ? AND (low_edge < ? AND top_edge >= ?)", category_id, volume, volume)
    return tariff.present? ? tariff[0].value.round(2) : 0
  end
end
