class TourguidesController < ApplicationController
  before_action :set_tourguide, only: [:show, :edit, :update, :destroy]
  before_action :check_company, only: [:show,:edit]
  # GET /tourguides
  # GET /tourguides.json
  def index
    @company = Company.all
    if session[:group] == "admin"
      if params[:fillter]
        @tourguides = Tourguide.search(params[:fillter]).order("created_at DESC").page(params[:page])
      else
        @tourguides = Tourguide.order(:name).page(params[:page])
      end
    else
       @company = Company.where(id:session[:company_id])
      if params[:fillter]
        @tourguides = Tourguide.search(params[:fillter],session[:company_id]).order("created_at DESC").page(params[:page])
      else
        @tourguides = Tourguide.where(company_id:session[:company_id]).order(:name).page(params[:page])
      end
    end
    # if params[:search]
    #   @tourguides = Tourguide.search(params[:search]).order("created_at DESC").page(params[:page])
    # else
    #   @tourguides = Tourguide.order(:name).page(params[:page])
    # end
  end

  # GET /tourguides/1
  # GET /tourguides/1.json
  def show
  end

  # GET /tourguides/new
  def new
    @tourguide = Tourguide.new
  end

  # GET /tourguides/1/edit
  def edit
  end

  # POST /tourguides
  # POST /tourguides.json
  def create
    @tourguide_params = tourguide_params
    if session[:company_id]
      @tourguide_params[:company_id] = session[:company_id]
    end
    if @tourguide_params[:device_id].blank?
      @tourguide_params[:device_id] = 0
    end
    @tourguide = Tourguide.new(@tourguide_params)
    if @tourguide_params['images']
      @tourguide['images'] = @tourguide_params['images'].original_filename
      upload = Tourguide.upload(@tourguide_params)
    end
    respond_to do |format|
      if @tourguide.save
        format.html { redirect_to @tourguide, notice: 'Tourguide was successfully created.' }
        format.json { render :show, status: :created, location: @tourguide }
      else
        format.html { render :new }
        format.json { render json: @tourguide.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tourguides/1
  # PATCH/PUT /tourguides/1.json
  def update
    respond_to do |format|
      if @tourguide.update(tourguide_params)
        format.html { redirect_to @tourguide, notice: 'Tourguide was successfully updated.' }
        format.json { render :show, status: :ok, location: @tourguide }
      else
        format.html { render :edit }
        format.json { render json: @tourguide.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tourguides/1
  # DELETE /tourguides/1.json
  def destroy
    @tourguide.destroy
    respond_to do |format|
      format.html { redirect_to tourguides_url, notice: 'Tourguide was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tourguide
      begin
        @tourguide = Tourguide.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render "layouts/not_found.html.erb"
      else
        @tourguide = Tourguide.find(params[:id])
      end
    end
    def check_company
      if session[:group] == "company"
        company_id = Tourguide.find(params[:id]).company_id
        if company_id != session[:company_id]
          redirect_to tourguides_path
        end
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def tourguide_params
      params.require(:tourguide).permit(:name, :address, :phone, :device_id, :active,:email,:gender,:images)
    end
end
