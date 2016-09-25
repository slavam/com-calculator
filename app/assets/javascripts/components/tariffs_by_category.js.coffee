# @cjsx React.DOM
R = React.DOM

@TariffsByCategory = React.createClass
  getInitialState: ->
    tariffs: @props.data
  getDefaultProps: ->
    tariffs: []
  render: -> 
    R.div 
      className: 'tariffs'
      R.h2
        className: 'title'
        'Тарифы'
      React.createElement TariffTable, tariffs: @props.data

@CategoryName = React.createClass
  render: ->
    R.tr null
    R.th colSpan: 2, #{@props.category}
        
@TariffRow = React.createClass
  render: ->
    R.tr null,
      R.td null, @props.tariff.name
      R.td null, @props.tariff.value
      R.td null, @props.tariff.start_date
      
@TariffTable = React.createClass
  render: ->
    rows = []
    lastCategory = null
    R.table
      className: 'table table-bordered'
      # for tariff in @props.tariffs
      #   React.createElement TariffRow, key: tariff.id, tariff: tariff
    #   `<h2>  "tariff.name" </h2>`
    #   if tariff.category.name != lastCategory
    #     categoryName = React.createElement CategoryName, key: tariff.category_id, category: tariff.category.name
    #     rows.push categoryName
    # tariffRow = React.createElement TariffRow, key: @props.tariffs[0].id, tariff: @props.tariffs[0]
    # rows.push tariffRow
    #   lastCategory = tariff.category.name
    R.table
        className: 'table table-bordered'
        R.thead null,
          R.tr null,
            R.th null, 'Название'
            R.th null, 'Значение'
            R.th null, 'Действует с'
        R.tbody null,
          for tariff in @props.tariffs
            React.createElement TariffRow, key: tariff.id, tariff: tariff
