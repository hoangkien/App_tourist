class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_filter  :verify_authenticity_token
  before_action :authorize,:stt
  protected
  def authorize
    unless User.find_by_account(session[:account])
       redirect_to sign_in_path, alert: "please sign in first!"
    end
  end
  def stt
    if params[:page]
      @stt = (params[:page].to_i-1)*4 +1
    else
      @stt = 1
    end
  end

  # def self.destroy(object, url)
  #   object.destroy
  #   respond_to do |format|
  #     format.html { redirect_to url, notice: 'Device was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

end
