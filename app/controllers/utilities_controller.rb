class UtilitiesController < ApplicationController
  before_action :set_flat, only: [:new, :create, :show, :edit, :update]
  before_action :set_utility, only: [:show, :edit, :update, :destroy]
  
  def index 
    if params[:flat_id]
      @utilities = Utility.where(flat_id: params[:flat_id])
    else
      @utilities = Utility.all.order(:flat_id, :id)
    end
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
    @utility.last_value_counter = @utility.start_value_counter if @utility.start_value_counter > 0

    if @utility.save
      render json: @utility
    else
      render json: @utility.errors, status: :unprocessable_entity
    end
  end

  def edit
  end
  
  def update
    respond_to do |format|
      if @utility.update(utility_params)
        format.html { redirect_to :flats, notice: 'utility was successfully updated.' }
        format.json { render :show, status: :ok, location: @utility }
      else
        format.html { render :edit }
        format.json { render json: @utility.errors, status: :unprocessable_entity }
      end
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
      params.require(:utility).permit(:flat_id, :category_id, :tariff_id, :description_counter, 
        :start_value_counter, :last_value_counter)
    end
  
end
