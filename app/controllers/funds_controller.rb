class FundsController < ApplicationController
  before_action :set_fund, only: [:edit, :update, :destroy]

  # GET /giving/funds
  def index
    @fund = Fund.all.order(:name)
  end

  # GET /giving/funds/new
  def new
    @fund = Fund.new
    if @logged_in.can_create?(@fund)
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  # GET /giving/funds/1/edit
  def edit
    if @logged_in.can_edit?(@fund)
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  # POST /giving/funds
  def create
    @fund = Fund.new(fund_params)
    if @logged_in.can_create?(@fund)
      if @fund.save
        redirect_to funds_url, notice: t('giving.funds.new.notice')
      else
        render :new
      end
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  # PATCH/PUT /giving/funds/1
  def update
    if @logged_in.can_edit?(@fund)
      if @fund.update(fund_params)
        redirect_to funds_url, notice: t('giving.funds.edit.notice')
      else
        render :edit
      end
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  # DELETE /giving/funds/1
  def destroy
    if @logged_in.can_delete?(@fund)
      @fund.destroy
      redirect_to funds_url, notice: t('giving.funds.destroy')
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  private

  def set_fund
    @fund = Fund.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def fund_params
    params.require(:fund).permit(:name, :display_name, :active, :online, :default_fund, :active_from, :active_to, :bank_account, :gl_account, :taxed)
  end
end
