class FeedbacksController < ApplicationController
  before_action :set_feedback, only: [:show, :edit, :update, :destroy]

  # GET /feedbacks
  # GET /feedbacks.json
  def index
    if session[:group] == "admin"
      if params[:search]
        @feedbacks = Feedback.search(params[:search].strip).order("created_at DESC").page(params[:page])
      else
        @feedbacks = Feedback.order(:id).page(params[:page])
      end
    else
      company_id = User.where(account:session[:account]).first.company_id
      if params[:search]
          @feedbacks = Feedback.search(params[:search].strip,company_id).order("created_at DESC").page(params[:page])
      else
        @feedbacks = Feedback.where(company_id:company_id).order(:id).page(params[:page])
      end 
    end
      # @filterrific = initialize_filterrific(
      #   Feedback,
      #   params[:filterrific]
      # ) or return
      # @feedbacks = @filterrific.find.page(params[:page])

      # respond_to do |format|
      #   format.html
      #   format.js
      #  end
  end

  # GET /feedbacks/1
  # GET /feedbacks/1.json
  def show
  end

  # GET /feedbacks/new
  def new
    @feedback = Feedback.new
  end

  # GET /feedbacks/1/edit
  def edit
  end

  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @feedback = Feedback.new(feedback_params)

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to @feedback, notice: 'Feedback was successfully created.' }
        format.json { render :show, status: :created, location: @feedback }
      else
        format.html { render :new }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /feedbacks/1
  # PATCH/PUT /feedbacks/1.json
  def update
    respond_to do |format|
      if @feedback.update(feedback_params)
        format.html { redirect_to @feedback, notice: 'Feedback was successfully updated.' }
        format.json { render :show, status: :ok, location: @feedback }
      else
        format.html { render :edit }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end
  def data
    
  end

  # DELETE /feedbacks/1
  # DELETE /feedbacks/1.json
  def destroy
    @feedback.destroy
    respond_to do |format|
      format.html { redirect_to feedbacks_url, notice: 'Feedback was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feedback
      begin
        @feedback = Feedback.find(params[:id])
      rescue ActiveRecord::RecordNotFound
       render "layouts/not_found.html.erb"
      else
        @feedback = Feedback.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feedback_params
      params.require(:feedback).permit(:quantiy_service, :comment, :traveller_id)
    end
end
