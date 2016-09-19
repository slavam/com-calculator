var Categories = React.createClass({
  render: function() {
    return (
      <div className="categories">
        <h1>Категории</h1>
        <CategoryTable data={this.props.data} />
      </div>
    );
  }
});

var CategoryRow = React.createClass({
  render: function() {
    return (
      <tr>
        <td>{this.props.category.name}</td>
        <td>{this.props.category.description}</td>
        <td>{this.props.category.unit}</td>
        <td>{this.props.category.is_counter ? "Да":"Нет"}</td>
      </tr>
    );
  }
});

var CategoryTable = React.createClass({
  render: function() {
    var rows = [];
    this.props.data.forEach(function(category) {
      rows.push(<CategoryRow category={category} key={category.id} />);
    }.bind(this));
    return (
      <table>
        <thead>
          <tr>
            <th>Название</th>
            <th>Описание</th>
            <th>Единица измерения</th>
            <th>По счетчику?</th>
          </tr>
        </thead>
        <tbody>{rows}</tbody>
      </table>
    );
  }
});

