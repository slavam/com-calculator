class TariffsController < ApplicationController
  before_action :set_tariff, only: [:show, :edit, :update, :destroy]

  # GET /tariffs
  # GET /tariffs.json
  def index
    @tariffs = Tariff.all.order(:category_id, :name)
  end
  
  private
    def set_tariff
      @tariff = Tariff.find(params[:id])
    end
  
    def tariff_params
      params.require(:tariff).permit(:name, :value, :start_date, :category_id)
    end

end
