class UsersController < ApplicationController
  require'digest/md5'
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_password, :update_password]
  before_action :check_permission ,only: [:index,:destroy]

  # GET /users
  # GET /users.json
  def index
    @company = Company.all
    @created_at = ["All","Day ago","Weeks ago","A month ago","Six month ago","Years ago"]
    # @users = User.all
    # @users = User.order(:name).page(params[:page])
    if params[:fillter]
      @users = User.search(params[:fillter]).order("account DESC").page(params[:page])
    else
       @users = User.order(:account).page(params[:page]).order("account DESC").page(params[:page])
    end
  end
  # GET /users/1
  # GET /users/1.json

  def search
    @users = User.order(:name).page(params[:page])
    render 'index'
  end
  def show
  end
  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    if session[:group] == "company"
      if params[:id] != session[:id].to_s
           redirect_to edit_user_path(session[:id])
      end
    end
    @user.company
    @company = Company.all
  end



  # POST /users
  # POST /users.json
  def create
    @user_params = user_params
    @user = User.new(@user_params)
    @params_company = company_params
      if user_params["group"] == 'company'#  group is company
        if company_params[:name].present? == true # company name is valid
          check_company = Company.where(name:company_params[:name]).first
          if check_company.nil? 
            @params_company[:code] = Company.generate_company_code
            @company = Company.new( @params_company)
            if @user.save
                if @company.save
                  @user_params[:company_id] = Company.last.id
                  user = User.last
                  if user.update_attributes(company_id: @user_params[:company_id])
                     user = User.last
                      redirect_to users_url, notice: 'User was successfully created.' 
                  else
                      render :new 
                  end
                end
            else
              render :new
            end
          else
            @company_errors="has already been taken"
            render :new
          end
        elsif company_params[:address].present? == false# company address is invalid 
          @company_errors = "Can't be blank"
          @company_errors_address = "Can't be blank"
          render :new
        else#company address is valid
          @company_errors_address = "Can't be blank"
          render :new
        end
      else
        if @user.save
            redirect_to users_url, notice: 'User was successfully created.' 
        else
            render :new 
        end
      end
    end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if session[:group]=="company" 
        @user = User.find(params[:id])
        @company = Company.find(@user.company_id)
         if @company.update(company_params) && @user.update(user_params_for_updating)
            format.html{ redirect_to user_path(params[:id], method: :get), notice:"Update successfully" }
         end
      elsif @user.update(user_params_for_updating)
        format.html { redirect_to users_url, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def edit_password
      @password = User.find(params[:id]).password
  end

  def update_password
    password = user_params_for_changing_password[:password]
    @user.update(password:Digest::MD5.hexdigest(password))
    redirect_to users_path
  end
  private
    def check_permission
      if session[:group] == 'company'
          redirect_to devices_path
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      begin
          @user = User.find(params[:id])  
      rescue ActiveRecord::RecordNotFound
         render "layouts/not_found.html.erb"
      else
          @user = User.find(params[:id]) 
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      if session[:group] == "company"
        params.require(:user).permit(:account, :password,:password_confirmation, :name, :address)
      else
        params.require(:user).permit(:account, :password,:password_confirmation, :name, :address, :group)
      end
    end
    def company_params
      params.require(:company).permit(:name,:address,:information)
    end
    def user_params_for_updating
      params.require(:user).permit(:name, :address, :group,:gender,:email)
    end
    def user_params_for_changing_password
      params.require(:user).permit( :password, :password_confirmation)
    end
    def params_fillter
      params.require(:fillter).permit(:account,:address,:name,:group,:company,:created_at)
    end
end
