class SessionsController < ApplicationController
  skip_before_filter :authorise
  
  def new
    respond_to do |format|
      format.html { render action: "sign_in" }
    end
  end
  
  def create
    user = User.find_by_username(params[:username])
    
    if (user && user.authenticate(params[:password])) # or (user && ) # FIXME allow for blank passwords
      session[:user_id] = user.id
      redirect_to root_url, notice: t('flash.sign_in', :name => user.first_name)
    else
      redirect_to sign_in_path, alert: t('flash.invalid_username_or_password')
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: t('flash.sign_out')
  end
end
