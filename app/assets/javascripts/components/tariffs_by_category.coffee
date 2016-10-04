# @cjsx React.DOM
R = React.DOM

@TariffsByCategory = React.createClass
  getInitialState: ->
    category: 1
  handleCategoryChange: (value) ->
    @setState category: +value
  render: -> 
    R.div 
      className: 'tariffs'

      R.h2
        className: 'categoryTitle'
        'Категория'

      React.createElement SelectCategory, categories: @props.categories, myOnChange: @handleCategoryChange

      R.h2
        className: 'title'
        'Тарифы'
        
      React.createElement TariffTable, tariffs: @props.data, category: @state.category

            
@SelectCategory = React.createClass      
  handleChange: ->
    @props.myOnChange @refs.selctCategory.value
  render: ->
    R.select
      className: 'selectCat'
      defaultValue: 1
      ref: 'selctCategory'
      onChange: @handleChange
      for category in @props.categories
        R.option
          key: category.id
          value: category.id
          category.name

@TariffTable = React.createClass
  render: ->
    R.table
        className: 'table table-bordered'
        R.thead null,
          R.tr null,
            R.th null, 'Название'
            R.th null, 'Значение'
            R.th null, 'Действует с'
        R.tbody null,
          for tariff in @props.tariffs
            if tariff.category_id == @props.category
              React.createElement TariffRow, key: tariff.id, tariff: tariff

@TariffRow = React.createClass
  render: ->
    <tr>
      <td>{@props.tariff.name}</td>
      <td>{@props.tariff.value}</td>
      <td>{@props.tariff.start_date}</td>
    </tr>
