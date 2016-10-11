R = React.DOM

@FlatUtilities = React.createClass
  getInitialState: ->
    utilities: @props.utilities
  addUtility: (record) ->
    utilities = @state.utilities.slice()
    utilities.push record
    @setState utilities: utilities

  render: -> 
    R.div 
      className: 'flat-utilities'

      R.h2
        className: 'h2Title'
        'Услуги для жилья'
      R.p null, "Адрес: "+@props.flat.address
      R.p null, "Плательщик: "+@props.flat.payer_lastname
    
      React.createElement RecordForm, categories: @props.categories, tariffs: @props.tariffs, handleNewUtility: @addUtility
      # React.createElement SelectCategory, categories: @props.categories, myOnChange: @handleCategoryChange

      R.h2
        className: 'title'
        'Услуги'
        
      React.createElement UtilityTable, utilities: @state.utilities, categories: @props.categories, tariffs: @props.tariffs

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
            React.createElement UtilityRow, key: utility.id, utility: utility, categories: @props.categories, tariffs: @props.tariffs
            
@UtilityRow = React.createClass
  render: ->
    category = (c for c in @props.categories when c.id is @props.utility.category_id)
    tariff = (t for t in @props.tariffs when t.id is @props.utility.tariff_id)
    R.tr null,
      R.td null, category[0].name
      R.td null, tariff[0].value
      R.td null, @props.utility.description_counter
      
@RecordForm = React.createClass
  getInitialState: ->
    category_id: 1
    tariff_id: 1
    tariffs: (tariff for tariff in @props.tariffs when tariff.category_id is 1)
    description_counter: ''
    start_value_counter: ''
  handleCategoryChange: (value) ->
    @setState category_id: +value    
    @setState tariffs: (tariff for tariff in @props.tariffs when tariff.category_id is +value)
  handleTariffChange: (value) ->
    @setState tariff_id: +value    
  handleChange: (e) ->
    name = e.target.name
    @setState "#{ name }": e.target.value
  handleSubmit: (e) ->
    e.preventDefault()
    $.post '', { utility: {category_id: @state.category_id, tariff_id: @state.tariff_id, description_counter: @state.description_counter, start_value_counter: @state.start_value_counter }}, (data) =>
      @props.handleNewUtility data
      @setState @getInitialState()
    , 'JSON'
  render: ->
    R.form
      className: 'form-inline'
      onSubmit: @handleSubmit
      R.div null
        # className: 'form-group'
        R.h4 
          className: 'form-control'
          "Категория: "
          React.createElement SelectCategory, categories: @props.categories, myOnChange: @handleCategoryChange
      R.br null
      R.div 
        className: 'form-group'
        R.h4 
          className: 'form-control'
          "Тариф: "
          React.createElement SelectTariff, tariffs: @state.tariffs, myOnChange: @handleTariffChange
      R.br null
      React.DOM.div
        className: 'form-group'
        R.h4 
          className: 'form-control'
          "Описание счетчика: "
          React.DOM.input
            type: 'text'
            # className: 'form-control'
            placeholder: 'Описание'
            name: 'description_counter'
            disabled: !(c for c in @props.categories when c.id is @state.category_id)[0].is_counter
            value: @state.description_counter
            onChange: @handleChange
      R.br null
      R.div
        className: 'form-group'
        R.h4
          className: 'form-control'
          "Начальное показание счетчика: "
          React.DOM.input
            type: 'number'
            # className: 'form-control'
            placeholder: 'Значение'
            name: 'start_value_counter'
            disabled: !(c for c in @props.categories when c.id is @state.category_id)[0].is_counter
            value: @state.start_value_counter
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