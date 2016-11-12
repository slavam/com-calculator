class CitiesController < ApplicationController
  def index
    @cities = City.all.order(:id)
  end
end
