@Tariffs = React.createClass
  getInitialState: ->
    tariffs: @props.data
  getDefaultProps: ->
    tariffs: []
  render: ->
    React.DOM.div
      className: 'tariffs'
      React.DOM.h2
        className: 'title'
        'Тарифы'
      React.DOM.table
        className: 'table table-bordered'
        React.DOM.thead null,
          React.DOM.tr null,
            React.DOM.th null, 'Название'
            React.DOM.th null, 'Значение'
            React.DOM.th null, 'Действует с'
        React.DOM.tbody null,
          for tariff in @state.tariffs
            React.createElement Tariff, key: tariff.id, tariff: tariff        