class FlatsController < ApplicationController
  before_action :set_flat, only: [:show, :edit, :update, :destroy]

  def get_owner
    owner = Owner.where("room_location_id = ?", params[:room_id])
    render json: owner[0].to_json
  end
  
  def get_city_streets
    streets = city_streets(params[:city_id])
    houses = street_houses(streets[0][:id])
    rooms = houses[0].present? ? house_rooms(houses[0][:id]) : []
    render json: {streets: streets, houses: houses, rooms: rooms}
  end
  
  def get_street_houses
    houses = street_houses(params[:street_id])
    rooms = houses[0].present? ? house_rooms(houses[0][:id]) : []
    render json: {houses: houses, rooms: rooms}
  end

  def get_house_rooms
    render json: {rooms: house_rooms(params[:house_id])}
  end
  
  def index
    @flats = Flat.all.order(:address)
  end
    
  def show
  end
  
  def new
    @flat = Flat.new
  end
  
  def new_by_address
    @cities = City.joins("INNER JOIN city_types ct ON ct.id = cities.city_type_id").order("cities.name").
      select("cities.id as id, CONCAT(ct.short_name, ' ', cities.name) as name")
    @streets = city_streets(1)
    @houses = street_houses(@streets[0][:id])
    @rooms = house_rooms(@houses[0][:id])
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
    
    def city_streets city_id
      streets = []
      query = "SELECT sl.id, sl.city_id, CONCAT(st.short_name, ' ', sl.name) as name 
        FROM street_locations sl 
        JOIN street_types st ON sl.street_type_id=st.id WHERE city_id=#{city_id} ORDER BY sl.name"
      StreetLocation.find_by_sql(query).each {|s|
        streets << {id: s.id, city_id: s.city_id, name: s.name}
      }
      streets
    end
    
    def street_houses street_id
      query = "SELECT hl.id as hl_id, hl.street_location_id, h.* 
        FROM house_locations hl
        JOIN houses h ON h.id = hl.house_id
        WHERE hl.street_location_id = #{street_id} 
        ORDER BY hl.street_location_id, h.n_house, h.d_house, h.a_house"
      houses = []
      HouseLocation.find_by_sql(query).each {|h|
        home = h.n_house.to_s + (h.f_house>0 ? '-' + h.f_house.to_s : '') + 
        (h.d_house>0 ? '/'+h.d_house.to_s : '') + 
        ((h.a_house.present? and h.a_house>'') ? '"'+h.a_house+'"' : '')
        houses << {id: h.hl_id, street_location_id: h.street_location_id, home: home}
      }
      houses
    end
    
    def house_rooms house_id
      query = "SELECT rl.id, house_location_id, n_room, a_room
        FROM room_locations rl
        JOIN rooms r on r.id=rl.room_id
        WHERE house_location_id = #{house_id}
        ORDER BY n_room, a_room"
      rooms = []
      RoomLocation.find_by_sql(query).each {|r|
        room = (r.n_room>0 ? r.n_room.to_s : '') +
        ((r.a_room.present? and r.a_room>'') ? '"'+r.a_room+'"' : '')
        rooms << {id: r.id, house_location_id: r.house_location_id, room: room}
      }
      rooms
    end
end
