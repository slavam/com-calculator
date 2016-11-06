class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]
  before_action :set_flat, only: [:index, :new, :show, :create, :update, :destroy]
  
  def get_tariff_by_volume
    render json: {tariff: Tariff.tariff_by_volume( params[:category_id], params[:volume])}
  end
  # GET /accounts
  # GET /accounts.json
  def index
    @accounts = @flat.accounts.order(:id).reverse_order
    # @accounts = Account.find(params[:flat_id]).order(:stop_date).reverse_order
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
  end

  # GET /accounts/new
  def new
    @utilities = @flat.utilities
    @x_u = []
    @utilities.each {|u| @x_u << u.as_json.merge({category_name: u.category.name, category_id: u.category_id,
      is_variable_tariff: u.category.is_variable_tariff, low_edge: u.tariff.low_edge, top_edge: u.tariff.top_edge,
      tariff_value: u.tariff.value, amount: u.payment, is_counter: u.category.is_counter})
    }
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = @flat.accounts.build(start_date: params[:start_date],
      stop_date: params[:end_date], total: params[:total], user_id: current_user.id)

    respond_to do |format|
      if @account.save
        params[:amounts].each {|key,a|
          utility = Utility.find(a[:utility_id])
          p = @account.payments.build(utility_id: a[:utility_id], amount: a[:amount], 
            tariff_value: utility.tariff.value,
            quantity: utility.category.is_counter ? a[:new_value].to_f - a[:old_value].to_f : utility.quantity,
            old_value_counter: a[:old_value], new_value_counter: a[:new_value])
          p.save
          utility.update(last_value_counter: a[:new_value]) if utility.category.is_counter
        }
        # }
        format.html { redirect_to flat_accounts_path, notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to flat_accounts_path, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:start_date, :stop_date, :total, :user_id, :flat_id)
      # params.fetch(:account, {})
    end
    
    def set_flat
      @flat = Flat.find(params[:flat_id])
    end
end
