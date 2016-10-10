R = React.DOM

@FlatUtilities = React.createClass
  getInitialState: ->
    category: 1
#   handleCategoryChange: (value) ->
#     @setState category: +value
  render: -> 
    R.div 
      className: 'flat-utilities'

      R.h2
        className: 'h2Title'
        'Услуги для жилья'
      R.p null, "Адрес: "+@props.flat.address
      R.p null, "Плательщик: "+@props.flat.payer_lastname
    
      React.createElement RecordForm, categories: @props.categories, tariffs: @props.tariffs
      # React.createElement SelectCategory, categories: @props.categories, myOnChange: @handleCategoryChange

      R.h2
        className: 'title'
        'Услуги'
        
      React.createElement UtilityTable, utilities: @props.utilities #, category: @state.category

@UtilityTable = React.createClass
  render: ->
    R.table
        className: 'table table-bordered'
        R.thead null,
          R.tr null,
            R.th null, 'Категория'
            R.th null, 'Тариф'
            R.th null, 'Счетчик'
        R.tbody null,
          for utility in @props.utilities
            React.createElement UtilityRow, key: utility.id, utility: utility
            
@UtilityRow = React.createClass
  render: ->
    R.tr null,
      R.td null, @props.utility.category.name
      R.td null, @props.utility.tariff.value
      R.td null, @props.utility.category.is_counter
      
@RecordForm = React.createClass
  getInitialState: ->
    category: 1
    tariffs: (tariff for tariff in @props.tariffs when tariff.category_id is 1)
  handleCategoryChange: (value) ->
    @setState category: +value    
    @setState tariffs: (tariff for tariff in @props.tariffs when tariff.category_id is +value)
  handleTariffChange: (value) ->
    @setState tariff_id: +value    
  handleSubmit: (e) ->
    e.preventDefault()
    $.post '', { record: @state }, (data) =>
      @props.handleNewRecord data
      @setState @getInitialState()
    , 'JSON'
  render: ->
    R.form
      className: 'form-inline'
      onSubmit: @handleSubmit
      R.div
        className: 'form-group'
        R.h4 null 
          "Категория: "
          React.createElement SelectCategory, categories: @props.categories, myOnChange: @handleCategoryChange
      R.br null
      R.div
        className: 'form-group'
        R.h4 null 
          "Тариф: "
          React.createElement SelectTariff, tariffs: @state.tariffs, myOnChange: @handleTariffChange
      R.br null
      R.div
        className: 'form-group'
        React.DOM.input
          type: 'number'
          className: 'form-control'
          placeholder: 'Amount'
          name: 'amount'
          disabled: !(c for c in @props.categories when c.id is @state.category)[0].is_counter
            # !@props.categories.find(c => c.id == @state.category).is_counter
          value: @state.amount
          onChange: @handleChange
      R.br null
      R.button
        type: 'submit'
        className: 'btn btn-primary'
        # disabled: !@valid()
        'Создать запись'      
            
@SelectCategory = React.createClass      
  handleChange: ->
    @props.myOnChange @refs.selectCategory.value
  render: ->
    R.select
      className: 'selectCat'
      defaultValue: 1
      ref: 'selectCategory'
      onChange: @handleChange
      for category in @props.categories
        R.option
          key: category.id
          value: category.id
          category.name
          
@SelectTariff = React.createClass      
  handleChange: ->
    @props.myOnChange @refs.selectTariff.value
  render: ->
    R.select
      className: 'selectTrf'
      defaultValue: 4
      ref: 'selectTariff'
      onChange: @handleChange
      for tariff in @props.tariffs
        R.option
          key: tariff.id
          value: tariff.id
          tariff.name          