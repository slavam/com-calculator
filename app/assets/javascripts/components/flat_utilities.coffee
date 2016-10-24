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
    
      R.h2
        className: 'h2Title'
        'Создать услугу'
      R.p null, 'Всего услуг - '+@state.utilities.length
      React.createElement RecordForm, categories: @props.categories, tariffs: @props.tariffs, handleNewUtility: @addUtility, utilities: @props.utilities, flat_id: @props.flat.id
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
            R.th null, 'Actions'
        R.tbody null,
          for utility in @props.utilities
            React.createElement UtilityRow, key: utility.id, utility: utility, categories: @props.categories, tariffs: @props.tariffs
            
@UtilityRow = React.createClass
  deleteClick: (e) ->
    e.preventDefault()
    $.get '', { id: @props.utility.id}, (data) =>
      null # @props.handleNewUtility data
      @setState @getInitialState()
    , 'JSON'
    
  render: ->
    category = (c for c in @props.categories when c.id is @props.utility.category_id)
    tariff = (t for t in @props.tariffs when t.id is @props.utility.tariff_id)
    R.tr null,
      R.td null, category[0].name
      R.td null, tariff[0].value
      R.td null, @props.utility.description_counter
      R.td null
        R.a 
          onClick: @deleteClick
          'Удалить'
      
@RecordForm = React.createClass
  getInitialState: ->
    category_id: 1
    tariff_id: 4
    description_counter: ''
    start_value_counter: ''
  handleCategoryChange: (value) ->
    @setState category_id: +value    
    @setState tariff_id: (tariff for tariff in @props.tariffs when tariff.category_id is +value)[0].id
  handleTariffChange: (value) ->
    @setState tariff_id: +value    
  handleChange: (e) ->
    name = e.target.name
    @setState "#{ name }": e.target.value
  handleSubmit: (e) ->
    e.preventDefault()
    $.post '', { flat_id: @props.flat_id, utility: {category_id: @state.category_id, tariff_id: @state.tariff_id, description_counter: @state.description_counter, start_value_counter: @state.start_value_counter }}, (data) =>
      @props.handleNewUtility data
      @setState @getInitialState()
    , 'JSON'
    document.getElementById("categorySelect").selectedIndex = "3";
    document.getElementById("tariffSelect").selectedIndex = "0";
    
  render: ->
    
    R.form
      className: 'form-inline'
      onSubmit: @handleSubmit
      R.div null
        # R.p null, 'Всего услуг - '+@state.utilities.length
        R.h4 
          className: 'form-control'
          "Категория: "
          React.createElement SelectCategory2, categories: @props.categories, myOnChange: @handleCategoryChange
      R.br null
      R.div null
        R.h4 
          className: 'form-control'
          "Тариф: "
          React.createElement SelectTariff2, tariffs: @props.tariffs, category_id: @state.category_id, myOnChange: @handleTariffChange
      R.br null
      R.div null
        R.h4 
          className: 'form-control'
          "Описание счетчика: "
          R.input
            type: 'text'
            placeholder: 'Описание'
            name: 'description_counter'
            disabled: !(c for c in @props.categories when c.id is @state.category_id)[0].is_counter
            value: @state.description_counter
            onChange: @handleChange
      R.br null
      R.div null
        R.h4
          className: 'form-control'
          "Начальное показание счетчика: "
          R.input
            type: 'number'
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
            
@SelectCategory2 = React.createClass      
  handleChange: ->
    @props.myOnChange @refs.selectCategory.value
  render: ->
    R.select
      id: 'categorySelect'
      defaultValue: 1
      ref: 'selectCategory'
      onChange: @handleChange
      for category in @props.categories
        R.option
          key: category.id
          value: category.id
          category.name
          
@SelectTariff2 = React.createClass      
  handleChange: ->
    @props.myOnChange @refs.selectTariff.value
  render: ->
    R.select
      className: 'selectTrf'
      id: 'tariffSelect'
      defaultValue: 4
      ref: 'selectTariff'
      onChange: @handleChange
      for tariff in @props.tariffs when tariff.category_id is @props.category_id
        R.option
          key: tariff.id
          value: tariff.id
          tariff.name          