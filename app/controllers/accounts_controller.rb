class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]
  before_action :set_flat, only: [:index, :new, :show, :update, :destroy]
  # GET /accounts
  # GET /accounts.json
  def index
    @accounts = @flat.accounts.order(:stop_date).reverse_order
    # @accounts = Account.find(params[:flat_id]).order(:stop_date).reverse_order
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
  end

  # GET /accounts/new
  def new
    # @account = Account.new
    @utilities = @flat.utilities
    @x_u = []
    @utilities.each {|u| @x_u << u.as_json.merge({category_name: u.category.name, 
      tariff_value: u.tariff.value, amount: u.payment, is_counter: u.category.is_counter})
    }
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)

    respond_to do |format|
      if @account.save
        # if @utility.tariff.is_counter
        #   counter = Counter.new(utility_id: @utility.id)
        # end

        format.html { redirect_to @account, notice: 'Account was successfully created.' }
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
      format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
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
