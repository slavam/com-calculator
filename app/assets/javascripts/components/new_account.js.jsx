var NewAccount = React.createClass({
  render: function() {
    return (
      <div className="new-account">
        <h1>Жилье</h1>
        <p>Адрес: {this.props.flat.address}</p>
      </div>
    );
  }
});
