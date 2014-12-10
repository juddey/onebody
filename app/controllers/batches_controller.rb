class BatchesController < ApplicationController
  before_action :set_batch, only: [:show, :edit, :update, :destroy]

  def index
    @batches = Batch.all.order(:name)
  end

  def show
  end

  def new
    @batches = Batch.new
    if @logged_in.can_create?(@batches)
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  def edit
    if @logged_in.can_edit?(@batches)
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  def create
    @batches = Batch.new(batch_params)

    if @logged_in.can_create?(@batches)
      if @batches.save
        redirect_to batches_url, notice: t('giving.batch.new.notice')
      else
        render :new
      end
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  def update
    if @logged_in.can_edit?(@batches)
      if @batches.update(batch_params)
        redirect_to batches_url, notice: t('giving.batch.edit.notice')
      else
        render :edit
      end
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  def destroy
    if @logged_in.can_delete?(@batches)
      @batches.destroy
      redirect_to batches_url, notice: t('giving.batch.destroy')
    else
      render text: t('not_authorized'), layout: true, status: 401
    end
  end

  private

  def set_batch
    @batches = Batch.find(params[:id])
  end

  def batch_params
    params.require(:batch).permit(:name, :opening_date, :deposit_date, :amount, :status, :batch_type, :comments)
  end
end
