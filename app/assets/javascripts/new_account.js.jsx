var AccountForm = React.createClass({
  getInitialState: function() {
    var now = new Date();
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var firstDay = now.getFullYear()+"-"+(month)+"-01" ;
    var date = new Date(now.getFullYear(), now.getMonth() + 1, 0);    
    month = ("0" + (date.getMonth() + 1)).slice(-2);
    var day = ("" + date.getDate()).slice(-2);
    var lastDay = date.getFullYear()+"-"+month+"-"+day;

    return {start_date: firstDay, end_date: lastDay};
  },
  handleStartDateChange: function(e) {
    this.setState({start_date: e.target.value});
  },
  handleEndDateChange: function(e) {
    this.setState({end_date: e.target.value});
  },
  handleSubmit: function(e) {
    e.preventDefault();
    var start_date = this.state.start_date;
    var end_date = this.state.end_date;
    if (!start_date || !end_date) {
      return;
    }
    this.props.onCommentSubmit({start_date: start_date, end_date: end_date});
    this.setState({start_date: '', end_date: ''});
  },
  render: function() {
    return (
      <div>
        <p>Период с: 
        <input
          type="month"
          placeholder="Начальная дата"
          value={this.state.start_date}
          onChange={this.handleStartDateChange}
        />
         по :
        <input
          type="text"
          placeholder="Конечная дата"
          value={this.state.end_date}
          onChange={this.handleEndDateChange}
        />
        </p>
        <h3>Услуги</h3>
        <UtilitiesTable utilities={this.props.utilities} start_date={this.state.start_date} end_date={this.state.end_date}/>
      </div>
    );
  }
});

class AccountUtilityRow extends React.Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
    this.state = {
      counterValue: this.props.utility.last_value_counter,
      tariffValue: this.props.utility.variables_tariffs[0].value,
      low_edge: this.props.utility.variables_tariffs[0].low_edge,
      top_edge: this.props.utility.variables_tariffs[0].top_edge
    };
  }
  handleChange() {
    this.setState({
      counterValue: this.refs.counterValue.value
    });
    const delta = this.refs.counterValue.value - this.props.utility.last_value_counter;
    if (delta >= 0 && this.props.utility.is_variable_tariff == true && (delta < this.state.low_edge || delta > this.state.top_edge)){
      // let ts = [];
      const ts = this.props.utility.variables_tariffs.filter(function(v_t) {
        return v_t.low_edge <= delta && delta <= v_t.top_edge;
      });
      this.setState({
        tariffValue: +ts[0].value,
        low_edge: ts[0].low_edge,
        top_edge: ts[0].top_edge
      });
      this.state.tariffValue = +ts[0].value;
      // $.ajax({
      // type: 'GET',
      // url: "get_tariff_by_volume?category_id="+this.props.utility.category_id+"&volume="+delta,
      // // data: data
      // })
      // .done(function(data) {
      //   // this.props.utility.tariff_value = data.tariff;
      //   this.setState({
      //     tariffValue: data.tariff,
      //     low_edge: data.low_edge,
      //     top_edge: data.top_edge
      //   });
      //   this.props.onUserInput(
      //   this.refs.counterValue.value,
      //   this.refs.counterValue.dataset.utilityid, // Importan! Only utilityid, not utilityId
      //   data.tariff
      //   );
      // }.bind(this))
      // .fail(function(jqXhr) {
      //   console.log('failed to register');
      // });
    }
    this.props.onUserInput(
      this.refs.counterValue.value,
      this.refs.counterValue.dataset.utilityid, // Importan! Only utilityid, not utilityId
      this.state.tariffValue
    );
  }  
  render() {
    return (
      <tr>
        <td>{this.props.utility.category_name}</td>
        <td>{(this.props.utility.is_counter && this.props.utility.category_name != "Водоотведение по счетчику") ? this.props.utility.last_value_counter : ''}</td>
        <td>{(this.props.utility.is_counter && this.props.utility.category_name != "Водоотведение по счетчику") ?
          <input
          type="text"
          size="10"
          value={this.state.counterValue}
          ref="counterValue"
          onChange={this.handleChange}
          data-utilityId={this.props.utility.id}
          /> : ''}
        </td>
        <td>{(this.props.utility.is_counter && this.props.utility.category_name != "Водоотведение по счетчику") ? (this.state.counterValue - this.props.utility.last_value_counter).toFixed(4) : ''}</td>
        <td>{this.props.utility.is_counter ? this.state.tariffValue : ''}</td>
        <td>{this.props.utility.amount ? this.props.utility.amount :
          ((this.state.counterValue - this.props.utility.last_value_counter)*this.state.tariffValue).toFixed(2)}
        </td>
      </tr>
    );
  }
}

class UtilitiesTable extends React.Component{
  constructor(props) {
    super(props);
    let amounts = [];
    this.props.utilities.forEach(function(utility) {
      amounts.push({utility_id: utility.id, amount: utility.amount, 
        old_value: utility.last_value_counter, new_value: utility.last_value_counter, 
        tariff: utility.variables_tariffs[0].value});
    });
    this.state = {
      counterValue: '',
      amounts: amounts
    };
    this.handleUserInput = this.handleUserInput.bind(this);
    this.handleAccountSubmit = this.handleAccountSubmit.bind(this);
  }
  handleUserInput(counterValue, utilityId, tariffValue) {
    let u;
    u = this.props.utilities.filter(function(utility) {
      return utility.id == utilityId;
    });
    let delta = +counterValue - u[0].last_value_counter;
    this.state.amounts.forEach(function(a, i) {
      if (a.utility_id == utilityId) {
        this.state.amounts[i].amount= +tariffValue * delta;
        this.state.amounts[i].new_value= counterValue;
        this.state.amounts[i].tariff = +tariffValue;
      }
    }.bind(this));
    if (u[0].category_name == "Горячее водоснабжение по счетчику"){
      let drain = this.props.utilities.filter(function(utility) {
        return (utility.category_name == "Водоотведение по счетчику") && (utility.description_counter == u[0].description_counter);
      });
      drain[0].amount = (delta * drain[0].variables_tariffs[0].value).toFixed(2);
      this.state.amounts.forEach(function(a, i) {
        if (a.utility_id == drain[0].id) {
          this.state.amounts[i].amount= drain[0].amount;
          this.state.amounts[i].new_value= counterValue;
          // this.state.amounts[i].tariff = +tariffValue;
        }
      }.bind(this));
    }
    this.refreshTotal();
    this.setState({
      counterValue: counterValue
    });
  }
  refreshTotal() {
    let total = 0;
    this.state.amounts.forEach(function(amount) {
      total += +amount.amount;
    }.bind(this));
    return total;
  }
  handleAccountSubmit(e) {
    e.preventDefault();
    // var self = this;
    var data = {
      amounts: this.state.amounts,
      start_date: this.props.start_date,
      end_date: this.props.end_date,
      total: this.refreshTotal()
    };

    // Submit form via jQuery/AJAX
    $.ajax({
      type: 'POST',
      url: "",
      data: data
    })
    .done(function(data) {
      null;
    })
    .fail(function(jqXhr) {
      console.log('failed to register');
    });
  }  
  render() {
    let rows = [];
    this.props.utilities.forEach(function(utility) {
      rows.push(<AccountUtilityRow utility={utility} key={utility.id} onUserInput={this.handleUserInput} />);
    }.bind(this));
    rows.push(<tr><td><b>Итого</b></td><td></td><td></td><td></td><td></td><td><b>{this.refreshTotal().toFixed(2)}</b></td></tr>);
    return (
      <form className="accountForm" onSubmit={this.handleAccountSubmit}>
        <table>
          <thead>
            <tr>
              <th>Название</th>
              <th>Было</th>
              <th>Стало</th>
              <th>Количество</th>
              <th>Тариф</th>
              <th>Сумма</th>
            </tr>
          </thead>
          <tbody>{rows}</tbody>
        </table>
        <input type="submit" value="Сохранить" />
      </form>
    );
  }
}

var NewAccount = React.createClass({
  render: function() {
    return (
      <div className="new-account">
        <h3>Жилье</h3>
        <p>Адрес: {this.props.flat.address}</p>
        <p>Владелец: {this.props.flat.payer_lastname+' '+this.props.flat.payer_firstname}</p>
        <AccountForm utilities={this.props.utilities} />
      </div>
    );
  }
});
