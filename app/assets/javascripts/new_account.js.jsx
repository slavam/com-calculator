var AccountForm = React.createClass({
  getInitialState: function() {
    var now = new Date();
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = now.getFullYear()+"-"+(month)+"-"+(day) ;

    return {start_date: today, end_date: today};
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
      <form className="accountForm" onSubmit={this.handleSubmit}>
        <input
          type="date"
          placeholder="Начальная дата"
          value={this.state.start_date}
          onChange={this.handleStartDateChange}
        />
        <input
          type="text"
          placeholder="Конечная дата"
          value={this.state.end_date}
          onChange={this.handleEndDateChange}
        />
        <h3>Услуги</h3>
        <UtilitiesTable utilities={this.props.utilities} categories={this.props.categories}/>
        <input type="submit" value="Сохранить" />
      </form>
    );
  }
});

var UtilityRow = React.createClass({
  getInitialState: function() {
    var old_value_counter = this.props.utility.last_value_counter;
    var new_value_counter = this.props.utility.last_value_counter;
    var amount = this.props.utility.amount ? this.props.utility.amount : 0;
    return {old_value_counter: old_value_counter, new_value_counter: new_value_counter, amount: amount};
  },
  render: function() {
    return (
      <tr>
        <td>{this.props.utility.category_name}</td>
        <td>{this.props.utility.is_counter ? this.state.old_value_counter : ''}</td>
        <td>{this.props.utility.is_counter ?
          <input
          type="text"
          value={this.state.new_value_counter}
          onChange={this.handleEndDateChange}
          /> : ''}
        </td>
        <td>{this.props.utility.is_counter ?
          <input
          type="text"
          value={this.state.new_value_counter - this.state.old_value_counter}
          onChange={this.handleEndDateChange}
          /> : ''}
        </td>
        <td>
          <input
          type="text"
          value={this.state.amount}
          onChange={this.handleEndDateChange}
          />
        </td>
      </tr>
    );
  }
});

var UtilitiesTable = React.createClass({
  render: function() {
    var rows = [];
    var category_name = '';
    var tariff_value = 0;
    this.props.utilities.forEach(function(utility) {
      rows.push(<UtilityRow utility={utility} key={utility.id} />);
    }.bind(this));
    return (
      <table>
        <thead>
          <tr>
            <th>Название</th>
            <th>Было</th>
            <th>Стало</th>
            <th>Количество</th>
            <th>Сумма</th>
          </tr>
        </thead>
        <tbody>{rows}</tbody>
      </table>
    );
  }
});

var NewAccount = React.createClass({
  render: function() {
    return (
      <div className="new-account">
        <h3>Жилье</h3>
        <p>Адрес: {this.props.flat.address}</p>
        <p>Владелец: {this.props.flat.payer_lastname+' '+this.props.flat.payer_firstname}</p>
        <p>Всего услуг: {this.props.utilities.length}</p>
        <AccountForm utilities={this.props.utilities} categories={this.props.categories} />
      </div>
    );
  }
});
