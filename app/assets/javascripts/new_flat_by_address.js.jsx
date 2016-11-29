class AddrSelect extends React.Component{
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
  }
  handleChange(event) {
    this.props.onUserInput(event.target.value);
  }
  render(){
    return <select className = "selectAddr" defaultValue = "1" onChange = {this.handleChange}>
      {
        this.props.data.map(function(elmnt) {
          return <option key = {elmnt.id} value = {elmnt.id}> {elmnt.name} </option>;
        }
      )}
    </select>;
  }
}

class RoomSelect extends React.Component{
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
  }
  handleChange(event) {
    this.props.onUserInput(event.target.value);
  }
  render(){
    return <select className = "selectRoom" defaultValue = "1" ref = "selectRoom" onChange = {this.handleChange}>
      {
        this.props.rooms.map(function(room) {
          return <option key = {room.id} value = {room.id}> {room.name} </option>;
        }
      )}
    </select>;
  }
}

class HouseSelect extends React.Component{
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
  }
  handleChange(event) {
    this.props.onUserInput(event.target.value);
  }
  render(){
    return <select className = "selectHouse" defaultValue = "1" ref = "selectHouse" onChange = {this.handleChange}>
      {
        this.props.houses.map(function(house) {
          return <option key = {house.id} value = {house.id}> {house.name} </option>;
        }
      )}
    </select>;
  }
}

class StreetSelect extends React.Component{
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
  }
  handleChange(event) {
    this.props.onUserInput(event.target.value);
  }
  render(){
    return <select className = "selectStreet" defaultValue = "1" ref = "selectStreet" onChange = {this.handleChange}>
      {
        this.props.streets.map(function(street) {
          return <option key = {street.id} value = {street.id}> {street.name} </option>;
        }
      )}
    </select>;
    
  }
}
class CitySelect extends React.Component{
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(event) {
    this.props.onUserInput(event.target.value);
  }
  render(){
    return <select className = "selectCity" defaultValue = "1" ref = "selectCity" onChange = {this.handleChange}>
      {
        this.props.cities.map(function(city) {
          return <option key = {city.id} value = {city.id}> {city.name} </option>;
        }
      )}
    </select>;
  }
}

class NewFlatByAddress extends React.Component{
  constructor(props){
    super(props);
    this.state = {
      streets: this.props.streets,
      houses: this.props.houses,
      rooms: this.props.rooms
    };
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleCitySelected = this.handleCitySelected.bind(this);
    this.handleStreetSelected = this.handleStreetSelected.bind(this);
    this.handleHouseSelected = this.handleHouseSelected.bind(this);
    this.handleRoomSelected = this.handleRoomSelected.bind(this);
  }  
  handleRoomSelected(room_id){
    $.ajax({
      type: 'GET',
      url: "get_owner?room_id="+room_id
      }).done(function(data) {
        // alert(data.full_name)
        this.setState({
          owner: data
        });
      }.bind(this))
      .fail(function(jqXhr) {
        console.log('failed to register');
      });
  }
  handleHouseSelected(house_id){
    $.ajax({
      type: 'GET',
      url: "get_house_rooms?house_id="+house_id
      }).done(function(data) {
        this.setState({
          rooms: data.rooms
        });
      }.bind(this))
      .fail(function(jqXhr) {
        console.log('failed to register');
      });
  }
  handleStreetSelected(street_id){
    $.ajax({
      type: 'GET',
      url: "get_street_houses?street_id="+street_id,
      }).done(function(data) {
        this.setState({
          houses: data.houses,
          rooms: data.rooms
        });
      }.bind(this))
      .fail(function(jqXhr) {
        console.log('failed to register');
      });
  }
  handleCitySelected(city_id){
    $.ajax({
      type: 'GET',
      url: "get_city_streets?city_id="+city_id,
      }).done(function(data) {
        this.setState({
          streets: data.streets,
          houses: data.houses,
          rooms: data.rooms
        });
      }.bind(this))
      .fail(function(jqXhr) {
        console.log('failed to register');
      });
  }
  handleSubmit(event) {
    // alert('Your favorite flavor is: ' + this.state.owner.id);
    event.preventDefault();
    $.ajax({
      type: 'POST',
      url: "create_by_address?owner_id="+this.state.owner.id
      }).done(function() {
        null;
      }) //.bind(this))
      .fail(function(jqXhr) {
        console.log('failed to register');
      });
  }
  render(){
    return (
      <form className="searchFlat" onSubmit={this.handleSubmit}>
        <p>Населенный пункт: 
          <CitySelect cities={this.props.cities} onUserInput={this.handleCitySelected}/>
        </p>
        <p>Улица: 
          <StreetSelect streets={this.state.streets} onUserInput={this.handleStreetSelected} />
        </p>
        <p>Дом: 
          <HouseSelect houses={this.state.houses} onUserInput={this.handleHouseSelected}/>
        </p>
        <p>Квартира: 
          <RoomSelect rooms={this.state.rooms} onUserInput={this.handleRoomSelected}/>
        </p>
        <br/>
        <input type="submit" value="Сохранить" />
      </form>
    );
  }
}
