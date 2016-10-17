class Utility < ActiveRecord::Base
  belongs_to :flat
  belongs_to :category
  belongs_to :tariff
  
  def payment
    return case category.name
      when 'Квартплата'
        self.tariff.value * self.flat.total_area
      when 'Электроэнергия'
        volume = self.counter.last_volume
        tariff = self.tariff.tariff_by_volume(volume)
        tariff * volume
      when 'Газ'
        self.tariff.value * self.flat.residents_number
      when 'Отопление'
        self.tariff.value * self.flat.heated_area
    end
  end
end
