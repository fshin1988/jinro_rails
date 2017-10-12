class VillagesController < ApplicationController
  before_action :set_village, only: [:show, :edit, :update, :destroy]

  # GET /villages
  # GET /villages.json
  def index
    @villages = Village.all
  end

  # GET /villages/1
  # GET /villages/1.json
  def show
  end

  # GET /villages/new
  def new
    @village = Village.new
  end

  # GET /villages/1/edit
  def edit
  end

  # POST /villages
  # POST /villages.json
  def create
    @village = Village.new(village_params)

    respond_to do |format|
      if @village.save
        format.html { redirect_to @village, notice: 'Village was successfully created.' }
        format.json { render :show, status: :created, location: @village }
      else
        format.html { render :new }
        format.json { render json: @village.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /villages/1
  # PATCH/PUT /villages/1.json
  def update
    respond_to do |format|
      if @village.update(village_params)
        format.html { redirect_to @village, notice: 'Village was successfully updated.' }
        format.json { render :show, status: :ok, location: @village }
      else
        format.html { render :edit }
        format.json { render json: @village.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /villages/1
  # DELETE /villages/1.json
  def destroy
    @village.destroy
    respond_to do |format|
      format.html { redirect_to villages_url, notice: 'Village was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_village
      @village = Village.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def village_params
      params.fetch(:village, {})
    end
end
