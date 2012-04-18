class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  before_filter :authorise
  
  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def authorise
    unless current_user
      redirect_to sign_in_path, notice: t('flash.please_sign_in') # FIXME: Turn 'Sign In' and 'Register' into clickable links and move the text out of the controller and into internationalisation file
    end
  end

  def authorise_action(user_id)
    return false unless @user_id = current_user
  end
  
  def paginate_at ()
    return 8
  end
  
end
