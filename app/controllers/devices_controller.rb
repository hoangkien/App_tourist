class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy]
  before_action :check_company , only: [:show,:edit]

  # GET /devices
  # GET /devices.json
  def index
    @company = Company.all
    @created_at = ["All","Day ago","Weeks ago","A month ago","Six month ago","Years ago"]
    if session[:group] == "admin"
      if params[:fillter]
        @devices = Device.search(params[:fillter]).order("created_at DESC").page(params[:page])
      else
        @devices = Device.order(:name).page(params[:page])
      end
    else
      @company = Company.where(id:session[:company_id])
      if params[:fillter]
          @devices = Device.search(params[:fillter],session[:company_id]).order("created_at DESC").page(params[:page])
      else
        @devices = Device.where(company_id:session[:company_id]).order(:name).page(params[:page])
      end 
    end
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
  end

  # GET /devices/new
  # def new
  #   @device = Device.new
  # end

  # GET /devices/1/edit
  # def edit
  # end

  # POST /devices
  # POST /devices.json
  # def create
  #   @device = Device.new(device_params)

  #   respond_to do |format|
  #     if @device.save
  #       format.html { redirect_to @device, notice: 'Device was successfully created.' }
  #       format.json { render :show, status: :created, location: @device }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @device.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  # def update
  #   respond_to do |format|
  #     if @device.update(device_params)
  #       format.html { redirect_to @device, notice: 'Device was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @device }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @device.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /devices/1
  # DELETE /devices/1.json
  # def destroy
  #   @device.destroy
  #   respond_to do |format|
  #     format.html { redirect_to devices_url, notice: 'Device was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      begin
        @device = Device.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render "layouts/not_found.html.erb"
      else
        @device = Device.find(params[:id])
      end
    end
    def check_company
      if session[:group] == "company"
        company_id_device = Device.find(params[:id]).company_id
        if company_id_device != session[:company_id]
          redirect_to devices_path
        end
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      params.require(:device).permit(:name, :status, :lat, :lng)
    end
end
