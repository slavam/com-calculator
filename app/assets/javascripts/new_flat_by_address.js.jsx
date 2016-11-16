class StreetSelect extends React.Component{
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
  }
  handleChange(event) {
    this.setState({street_id: event.target.value});
    // this.props.myOnChange(this.refs.selectCity.value);
    // alert(event.target.value)
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
    // this.handleSubmit = this.handleSubmit.bind(this);
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
    let s;
    s = this.props.streets.filter(function(street) {
      return street.city_id == 1;
    });
    this.state = {
      // city_id: 1,
      streets: s
    };
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleCitySelected = this.handleCitySelected.bind(this);
  }  
  handleCitySelected(city_id){
    let s;
    s = this.props.streets.filter(function(street) {
      return street.city_id == city_id;
    });
    // this.state.streets = s;
    this.setState({
      // city_id: city_id,
      streets: s
    });
  }
  handleSubmit(event) {
    alert('Your favorite flavor is: ' + this.state.city_id);
    event.preventDefault();
  }
  render(){
    return (
      <form className="searchFlat" onSubmit={this.handleSubmit}>
        <p>Населенный пункт: 
          <CitySelect cities={this.props.cities} onUserInput={this.handleCitySelected}/>
        </p>
        <p>Улица: 
          <StreetSelect streets={this.state.streets} />
        </p>
        <br/>
        <input type="submit" value="Найти" />
      </form>
    );
  }
}
