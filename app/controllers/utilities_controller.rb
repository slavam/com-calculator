class UtilitiesController < ApplicationController
  before_action :set_flat, only: [:new, :create, :show, :edit, :update]
  before_action :set_utility, only: [:show, :destroy]
  
  def index 
    @utilities = Utility.all.order(:flat_id, :id)
  end
  
  def show
  end
  
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

  def destroy
    @utility.destroy
    respond_to do |format|
      format.html { redirect_to utilities_url, notice: 'Услуга была удалена.' }
      format.json { head :no_content }
    end
  end
  
private
    def set_flat
      @flat = Flat.find(params[:flat_id])
    end
  
    def set_utility
      @utility = Utility.find(params[:id])
    end
    
    def utility_params
      params.require(:utility).permit(:flat_id, :category_id, :tariff_id, :description_counter, :start_value_counter)
    end
  
end
