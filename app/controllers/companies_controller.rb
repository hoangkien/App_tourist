class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, only: [:index,:destroy]

  # GET /companies
  # GET /companies.json

  def index
    if params[:search]
      @companies = Company.search(params[:search].strip).order("created_at DESC").page(params[:page])
    else
      @companies = Company.order(:name).page(params[:page])
    end
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
  end

  # GET /companies/new
  def new
    @company = Company.new
    @company.code = Company.generate_company_code
  end

  # GET /companies/1/edit
  def edit
    if session[:group] =='company'
      if params[:id].to_s != session[:company_id].to_s
        redirect_to edit_company_path(session[:company_id])
      end
    end
  end

  # POST /companies
  # POST /companies.json
  def create
    new_params = company_params
    new_params[:code] = Company.generate_company_code
    @company = Company.new(new_params)
    respond_to do |format|
      if @company.save
        format.html { redirect_to companies_url, notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to companies_url, notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    # ApplicationController.destroy(@company,:companies_url)
    
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      begin
        @company = Company.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to companies_path, :notice =>"Invalid Company"
      else
        @company = Company.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
     params.require(:company).permit(:name, :address)
    end
    def require_admin
      if session[:group] == 'company'
          redirect_to edit_company_path(session[:company_id])
      end
    end
end
