class Tariff < ActiveRecord::Base
  belongs_to :category
  validates :name, :value, :category_id, presence: true
  
  def self.tariff_by_volume category_id, volume
    tariff = self.where("category_id = ? AND (low_edge < ? AND top_edge >= ?)", category_id, volume, volume)
    return tariff.present? ? {
      tariff: tariff[0].value.round(2),
      low_edge: tariff[0].low_edge,
      top_edge: tariff[0].top_edge
    } : null
  end
  
  def self.variables_tariffs category_id
    self.where(category_id: category_id).select("id, value, low_edge, top_edge").order(:low_edge).map{|t|
      {id: t.id, value: t.value, low_edge: t.low_edge, top_edge: t.top_edge}
    }
  end
end
