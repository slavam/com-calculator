@Tariff = React.createClass
  render: ->
    React.DOM.tr null,
      React.DOM.td null, @props.tariff.name
      React.DOM.td null, @props.tariff.value
      React.DOM.td null, @props.tariff.start_date