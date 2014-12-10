class BatchLinesController < ApplicationController
  before_action :set_batch_line, only: [:show, :edit, :update, :destroy]

  # GET /batch_lines
  def index
    @batch_lines = BatchLine.all
  end

  # GET /batch_lines/1
  def show
  end

  # GET /batch_lines/new
  def new
    @batch_line = BatchLine.new
  end

  # GET /batch_lines/1/edit
  def edit
  end

  # POST /batch_lines
  def create
    @batch_line = BatchLine.new(batch_line_params)

    if @batch_line.save
      redirect_to @batch_line, notice: 'Batch line was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /batch_lines/1
  def update
    if @batch_line.update(batch_line_params)
      redirect_to @batch_line, notice: 'Batch line was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /batch_lines/1
  def destroy
    @batch_line.destroy
    redirect_to batch_lines_url, notice: 'Batch line was successfully destroyed.'
  end

  private

  def set_batch_line
    @batch_line = BatchLine.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def batch_line_params
    params.require(:batch_line).permit(:amount, :person_id, :tender, :fund_id)
  end
end
