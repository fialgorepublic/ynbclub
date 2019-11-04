class GroupsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :search, :users]
  before_action :set_group, only: [:show, :edit, :update, :destroy, :users]

  def index
    groups = Group.all
    groups = groups.sort_by_title(params[:sort_type]) if params[:sort_type].present?
    groups = groups.filter_by_categories(params[:category_ids]) if params[:category_ids].present?
    @groups = groups.with_attached_logo.paginate(page: params[:page], per_page: 9)
    @next_page = @groups.next_page
    set_group_categories

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        flash[:success] =  'Group was successfully created.' 
        format.html { redirect_to @group }
        format.json { render :show, status: :created, location: @group }
      else
        flash[:alert] = @group.errors.full_messages.to_sentence
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        flash[:success] =  'Group was successfully updated.'
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        flash[:alert] = @group.errors.full_messages.to_sentence
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search
    @groups = Group.filter_by_name(params[:group_title])
  end

  def banner
    @page.update(group_banner: params[:page][:group_banner])
    redirect_to groups_path
  end

  def users
    @users = @group.users
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :description, :logo, :group_category_id)
    end

    def set_group_categories
      @group_categories ||= GroupCategory.all
    end
end
