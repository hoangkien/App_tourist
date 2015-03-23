class ToursController < ApplicationController
  before_action :set_tour, only: [:show, :edit, :update, :destroy,:list_users]
  before_action :check_company, only:[:show,:edit]
  skip_before_action :set_tour , only: [:add_tourguide,:remove_tourguide]
  # GET /tours
  # GET /tours.json
  def index
     if session[:group] == "admin"
      if params[:search]
        @tours = Tour.search(params[:search].strip).order("created_at DESC").page(params[:page])
      else
        @tours = Tour.order(:name).page(params[:page])
      end
    else
      if params[:search]
        @tours = Tour.search(params[:search],session[:company_id].strip).order("created_at DESC").page(params[:page])
      else
        @tours = Tour.where(company_id:session[:company_id]).order(:name).page(params[:page])
      end
    end
    # if params[:search]
    #   @tours = Tour.search(params[:search]).order("created_at DESC").page(params[:page])
    # else
    #   @tours = Tour.order(:name).page(params[:page])
    # end
  end

  # GET /tours/1
  # GET /tours/1.json
  def show
  end

  # GET /tours/new
  def new
    @tour = Tour.new
  end

  # GET /tours/1/edit
  def edit
  end

  # POST /tours
  # POST /tours.json
  def create
    @tour_params = tour_params
    if session[:group] == "company"
      @tour_params[:company_id] = session[:company_id]
    end
    @tour = Tour.new(@tour_params)

    respond_to do |format|
      if @tour.save
        format.html { redirect_to tours_path, notice: 'Tour was successfully created.' }
        format.json { render :show, status: :created, location: @tour }
      else
        format.html { render :new }
        format.json { render json: @tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tours/1
  # PATCH/PUT /tours/1.json
  def update
    respond_to do |format|
      if @tour.update(tour_params)
        format.html { redirect_to @tour, notice: 'Tour was successfully updated.' }
        format.json { render :show, status: :ok, location: @tour }
      else
        format.html { render :edit }
        format.json { render json: @tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tours/1
  # DELETE /tours/1.json
  def destroy
    @tour.destroy
    respond_to do |format|
      format.html { redirect_to tours_url, notice: 'Tour was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def list_users

      #   @tour = Tour.find(params[:id])

      @traveller_list = @tour.travellers

      @tourguide_list = @tour.tourguides
      if session[:group] == "admin"
        @tourguides = Tourguide.where("active = 0 or active is NULL"  )
        @travellers = Traveller.where("active = 0 or active is NULL")
        @devices = Device.where("status = 0 or status is NULL")
      else
        @tourguides = Tourguide.where("active = 0 and company_id=#{session[:company_id]}")
        @travellers = Traveller.where("active = 0 and company_id =#{session[:company_id]}")
        @devices = Device.where("status = 0 and company_id = #{session[:company_id]}")
      end
  end
  def add_tourguide
    @tourguide = Tourguide.find(params[:tourguide])
    @tourguide.update(active:1,device_id:params[:device])
    @device = Device.find(params[:device])
    @device.update(status:1)
    @tour = Tour.find(params[:tour_id])
    @tourguide.tours << @tour
    redirect_to list_user_path(params[:tour_id]),alert: 'Tourguide was successfully added.'
  end
  def add_traveller
    @traveller = Traveller.find(params[:traveller])
    @traveller.update(active:1)
    @tour = Tour.find(params[:tour_id])
    @traveller.tours << @tour
    redirect_to list_user_path(params[:tour_id]),alert: 'Traveller was successfully added.'
  end
  def remove_traveller
    @tour=Tour.find(params[:tour_id])
    @traveller = Traveller.find(params[:traveller_id])
    unless @traveller.device_id == 0
      @device = Device.find(@traveller.device_id)
      @device.update(status:0,lat:'21.03005',lng:'105.785025')
    end
    #delete traveller in tour
    @traveller.tours.delete(@tour)
    #delete device in traveller
    @traveller.update(device_id:0,active:0)
    redirect_to list_user_path(params[:tour_id]), notice:"Traveller was successfully destroyed" 
    
  end
  def remove_tourguide
    @tour = Tour.find(params[:tour_id])
    @tourguide = Tourguide.find(params[:tourguide_id])
    unless @tourguide.device_id == 0
      @device = Device.find(@tourguide.device_id)
      @device.update(status:0,lat:'21.03005',lng:'105.785025')
    end
    #delete tourguide in tour
    @tourguide.tours.delete(@tour)
    #update device_id and active of tourguide 
    @tourguide.update(active:nil,device_id:0)
    #update status device
    redirect_to list_user_path(params[:tour_id]), alert:"Tourguide was successfully destroyed"
  end
  def disconnect_device
      if params[:group] == "1"
        tourguide = Tourguide.find(params[:user_id])
        tourguide.update(device_id:0)
      else
        traveller = Traveller.find(params[:user_id])
        traveller.update(device_id:0)
      end
      
      device = Device.find(params[:device_id])
      device.update(status:0,lat:'21.03005',lng:'105.785025')
      redirect_to list_user_path(params[:tour_id])
  end
  def change_device
      if params[:group] == "1"
           user = Tourguide.find(params[:user_id])
           user.update(device_id:params[:device_id])
      else
        user = Traveller.find(params[:user_id])
        user.update(device_id:params[:device_id])
      end
      device_old = Device.find(user.device_id)
      device_old.update(status:0)
      device_new = Device.find(params[:device_id])
      device_new.update(status:1)
      redirect_to list_user_path(params[:tour_id])

  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tour
      begin
        @tour = Tour.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render "layouts/not_found.html.erb"
        # redirect_to tourguides_path, :notice =>"Invalid Tourguide"
      else
        @tour = Tour.find(params[:id])
      end
    end
    def check_company
      if session[:group] == "company"
        company_id_tour = Tour.find(params[:id]).company_id
        if company_id_tour != session[:company_id]
          redirect_to tours_path
        end
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def tour_params
      params.require(:tour).permit(:name, :number_of_member, :information)
    end
end
