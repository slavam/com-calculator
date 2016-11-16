class Utility < ActiveRecord::Base
  belongs_to :flat
  belongs_to :category
  belongs_to :tariff
  # has_one :counter
  # validates :start_value_counter, presence: true if category.is_counter
  
  def payment
    return case category.name
      when 'Квартплата'
        self.tariff.value * self.flat.total_area
      # when 'Электроэнергия'
        # volume = self.counter.last_volume
        # tariff = self.tariff.tariff_by_volume(volume)
        # tariff * volume
      when 'Газ'
        self.tariff.value * self.flat.residents_number
      when 'Отопление'
        (self.tariff.value * self.flat.heated_area).round(2)
      else
        0
    end
  end
  def quantity
    return case category.name
      when 'Квартплата'
        self.flat.total_area
      # when 'Электроэнергия'
        # volume = self.counter.last_volume
        # tariff = self.tariff.tariff_by_volume(volume)
        # tariff * volume
      when 'Газ'
        self.flat.residents_number
      when 'Отопление'
        self.flat.heated_area.round(2)
    end
  end
  def name_with_counter
    self.category.name+" ("+description_counter+")"
  end
end
