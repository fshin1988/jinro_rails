class ManualsController < ApplicationController
  before_action :set_manual, only: %i[show edit update destroy]
  before_action :authorize_manual, only: %i[show new create edit update destroy]

  def show
  end

  def new
    @manual = Manual.new
  end

  def edit
  end

  def create
    @manual = Manual.new(manual_params)

    if @manual.save
      redirect_to @manual, notice: 'マニュアルを作成しました'
    else
      render :new
    end
  end

  def update
    if @manual.update(manual_params)
      redirect_to @manual, notice: 'マニュアルを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @manual.destroy
    redirect_to manuals_url, notice: 'マニュアルを削除しました'
  end

  private

  def set_manual
    @manual = Manual.find(params[:id])
  end

  def authorize_manual
    authorize Manual
  end

  def manual_params
    params.require(:manual).permit(:content)
  end
end
