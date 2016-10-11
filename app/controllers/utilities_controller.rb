class UtilitiesController < ApplicationController
  before_action :set_flat, only: [:new, :create, :show, :edit, :update, :destroy]
  
  def new
    @utilities = @flat.utilities.order(:id)
    @categories = Category.all.order(:name)
    @tariffs = Tariff.all.order(:name)
  end
  
  def create
    @utility = Utility.new(utility_params)
    @utility.flat_id = @flat.id

    if @utility.save
      render json: @utility
    else
      render json: @utility.errors, status: :unprocessable_entity
    end
  end
  
private
    def set_flat
      @flat = Flat.find(params[:flat_id])
    end
  
    def utility_params
      params.require(:utility).permit(:flat_id, :category_id, :tariff_id, :description_counter, :start_value_counter)
    end
  
end
