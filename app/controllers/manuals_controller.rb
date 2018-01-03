class ManualsController < ApplicationController
  before_action :set_manual, only: [:show, :edit, :update, :destroy]

  # GET /manuals
  # GET /manuals.json
  def index
    @manuals = Manual.all
  end

  # GET /manuals/1
  # GET /manuals/1.json
  def show
  end

  # GET /manuals/new
  def new
    @manual = Manual.new
  end

  # GET /manuals/1/edit
  def edit
  end

  # POST /manuals
  # POST /manuals.json
  def create
    @manual = Manual.new(manual_params)

    respond_to do |format|
      if @manual.save
        format.html { redirect_to @manual, notice: 'Manual was successfully created.' }
        format.json { render :show, status: :created, location: @manual }
      else
        format.html { render :new }
        format.json { render json: @manual.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manuals/1
  # PATCH/PUT /manuals/1.json
  def update
    respond_to do |format|
      if @manual.update(manual_params)
        format.html { redirect_to @manual, notice: 'Manual was successfully updated.' }
        format.json { render :show, status: :ok, location: @manual }
      else
        format.html { render :edit }
        format.json { render json: @manual.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manuals/1
  # DELETE /manuals/1.json
  def destroy
    @manual.destroy
    respond_to do |format|
      format.html { redirect_to manuals_url, notice: 'Manual was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manual
      @manual = Manual.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manual_params
      params.require(:manual).permit(:content)
    end
end
