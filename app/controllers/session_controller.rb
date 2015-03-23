class SessionController < ApplicationController
  require'digest/md5'
  skip_before_action :authorize #, only: [:create]
  def new
    if session[:account]
      redirect_to users_url
    else
      @user =  User.new
      render :layout => 'layouts/sign_in'
    end
  end

  def create
      user = User.login(params[:account],Digest::MD5.hexdigest(params[:password]))
      if user
        # session[:user]=  {:id => user.id, :account => user.account,:group => user.group}
        session[:account]= user.account
        session[:group] =  user.group
        session[:id] = user.id
        if user.group == 'company'
          session[:company_id] = user.company_id
        end
        redirect_to users_url
      else
          redirect_to sign_in_path, alert: "Invalid user/password combination"
      end

  end

  def destroy
    session[:account] = nil
    session[:group] = nil
    if session[:company_id]
      session[:company_id] = nil
    end
    # abort(session[:company_id].to_s)
    redirect_to sign_in_url
  end
end
