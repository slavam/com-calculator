class FlatsController < ApplicationController
  before_action :set_flat, only: [:show, :edit, :update, :destroy]
  
  def index
    @flats = Flat.all.order(:address)
  end
    
  def show
  end
  
  def new
    @flat = Flat.new
  end
  
  def new_by_address
    @cities = []
    @streets = []
    # City.all.order(:name).each {|c|
    City.where("id in (1,2)").order(:name).each {|c|  # development mode
      @cities << {id: c.id, name: c.city_type.short_name+' '+c.name} 
    }
    StreetLocation.where("city_id in (1,2)").order(:city_id, :name).each {|s|
      @streets << {id: s.id, city_id: s.city_id, name: s.street_type.short_name+' '+s.name}
    }
  end
  
  def create
    @flat = Flat.new(flat_params)
    
    respond_to do |format|
      @flat.user_id = current_user.id if current_user
      if @flat.save
        format.html { redirect_to :flats, notice: 'flat was successfully created.' }
        format.json { render :show, status: :created, location: @flat }
      else
        format.html { render :new }
        format.json { render json: @flat.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
  end
  
  def update
    respond_to do |format|
      if @flat.update(flat_params)
        format.html { redirect_to :flats, notice: 'flat was successfully updated.' }
        format.json { render :show, status: :ok, location: @flat }
      else
        format.html { render :edit }
        format.json { render json: @flat.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @flat.destroy
    respond_to do |format|
      format.html { redirect_to flats_url, notice: 'Flat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
private
    def set_flat
      @flat = Flat.find(params[:id])
    end
  
    def flat_params
      params.require(:flat).permit(:address, :payer_firstname, :payer_middlename, :payer_lastname, :user_id, 
        :residents_number, :total_area, :heated_area)
    end
    
end
