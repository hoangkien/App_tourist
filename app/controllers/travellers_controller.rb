class TravellersController < ApplicationController
  before_action :set_traveller, only: [:show, :edit, :update, :destroy]
  before_action :check_company, only:[:show,:edit]
  # GET /travellers
  # GET /travellers.json
  def index
    @company = Company.all
    if session[:group] == "admin"
      if params[:fillter]
        @travellers = Traveller.search(params[:fillter]).order("created_at DESC").page(params[:page])
      else
        @travellers = Traveller.order(:name).page(params[:page])
      end
    else
      @company = Company.where(id:session[:company_id])
      if params[:fillter]
        @travellers = Traveller.search(params[:fillter],session[:company_id]).order("created_at DESC").page(params[:page])
      else
        @travellers = Traveller.where(company_id:session[:company_id]).order(:name).page(params[:page])
      end 
    end
    # if params[:search]
    #   @travellers = Traveller.search(params[:search]).order("created_at DESC").page(params[:page])
    # else
    #   @travellers = Traveller.order(:name).page(params[:page])
    # end
  end

  # GET /travellers/1
  # GET /travellers/1.json
  def show
  end

  # GET /travellers/new
  def new
    if session[:group] == "company"
      @devices = Device.where(status:0,company_id:session[:company_id])
    else
      @devices = Device.where(status:0)
    end
    @traveller = Traveller.new
    if session[:group] == "company"
      @company_id = session[:company_id]
    end
  end

  # GET /travellers/1/edit
  def edit
    if session[:group] == "company"
      @devices = Device.where(status:0,company_id:session[:company_id])
    else
      @devices = Device.where(status:0)
    end
  end

  # POST /travellers
  # POST /travellers.json
  def create
    # abort(traveller_params[:device_id])
    if session[:group] == "company"
      #select device of company where status = 0
      @devices = Device.where(status:0,company_id:session[:company_id])
    else
      #select all device where status  = 0
      @devices = Device.where(status:0)
    end
    @traveller_params = traveller_params
    if @traveller_params[:device_id].blank?
      @traveller_params[:device_id] = 0
    end
    if session[:company_id]
      @traveller_params[:company_id] = session[:company_id]
    end
    @traveller = Traveller.new(@traveller_params)
    #upload anh
    if @traveller_params['images']
      @traveller['images'] = @traveller_params['images'].original_filename
      upload = Traveller.upload(@traveller_params)
    end
    respond_to do |format|
      #if params[:tour_id]
      if @traveller.save && params[:tour_id]
        tour = Tour.find(params[:tour_id])
        traveller = Traveller.last
        #add traveller in tour
        traveller.tours << tour
        unless traveller_params[:device_id].blank?
          device = Device.find(traveller_params[:device_id])
          #change status device =>true
          device.update(status:1)
        end
        #redirect_to tours > list_user
        format.html{redirect_to list_user_path(params[:tour_id]), notice: 'Traveller was successfully created.'}
      elsif @traveller.save
        format.html { redirect_to travellers_path, notice: 'Traveller was successfully created.' }
        format.json { render :show, status: :created, location: @traveller }
      else
        format.html { render :new }
        format.json { render json: @traveller.errors, status: :unprocessable_entity }
      end
    end
  end
  # PATCH/PUT /travellers/1
  # PATCH/PUT /travellers/1.json
  def update
    respond_to do |format|
      if @traveller.update(traveller_params)
        format.html { redirect_to @traveller, notice: 'Traveller was successfully updated.' }
        format.json { render :show, status: :ok, location: @traveller }
      else
        format.html { render :edit }
        format.json { render json: @traveller.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /travellers/1
  # DELETE /travellers/1.json
  def destroy
    @traveller.destroy
    respond_to do |format|
      format.html { redirect_to travellers_url, notice: 'Traveller was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_traveller
      begin
         @traveller = Traveller.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render "layouts/not_found.html.erb"   
      else
        @traveller = Traveller.find(params[:id])
      end
    end
    def check_company
      if session[:group] == "company"
        company_id = Traveller.find(params[:id]).company_id
        if company_id != session[:company_id]
          redirect_to travellers_path
        end
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def traveller_params
      params.require(:traveller).permit(:name, :address, :phone, :device_id,:gender,:images)
    end
end
