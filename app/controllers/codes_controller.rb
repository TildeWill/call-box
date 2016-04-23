class CodesController < ApplicationController
  before_action :set_code, only: [:show, :edit, :update, :destroy]

  def index
    @codes = Code.all
  end

  def new
    @code = Code.new
  end

  def edit
  end

  def create
    @code = Code.new(code_params)

    if @code.save
      redirect_to codes_path, notice: 'Code was successfully created.'
    else
      render :new
    end
  end

  def update
    if @code.update(code_params)
      redirect_to codes_path, notice: 'Code was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @code.destroy
    redirect_to codes_path, notice: 'Code was successfully destroyed.'
  end

  private
    def set_code
      @code = Code.find(params[:id])
    end

    def code_params
      params.require(:code).permit(:name, :code)
    end
end
