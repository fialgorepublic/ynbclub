class PointTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!
  before_action :set_point_type, only: [:show, :edit, :update, :destroy]

  # GET /point_types
  # GET /point_types.json
  def index
    @point_types = PointType.where(is_deleted: false)
  end

  # GET /point_types/1
  # GET /point_types/1.json
  def show
  end

  # GET /point_types/new
  def new
    @point_type = PointType.new
  end

  # GET /point_types/1/edit
  def edit
  end

  # POST /point_types
  # POST /point_types.json
  def create
    @point_type = PointType.new(point_type_params)

    respond_to do |format|
      if @point_type.save
        format.html { redirect_to @point_type, notice: 'Reward was successfully created.' }
        format.json { render :show, status: :created, location: @point_type }
      else
        format.html { render :new }
        format.json { render json: @point_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /point_types/1
  # PATCH/PUT /point_types/1.json
  def update
    respond_to do |format|
      if @point_type.update(point_type_params)
        format.html { redirect_to @point_type, notice: 'Reward was successfully updated.' }
        format.json { render :show, status: :ok, location: @point_type }
      else
        format.html { render :edit }
        format.json { render json: @point_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /point_types/1
  # DELETE /point_types/1.json
  def destroy
    @point_type.update_attributes(is_deleted: true)
    # @point_type.destroy
    respond_to do |format|
      format.html { redirect_to point_types_url, notice: 'Reward was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_point_type
      @point_type = PointType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def point_type_params
      params.require(:point_type).permit(:name, :point)
    end
end
