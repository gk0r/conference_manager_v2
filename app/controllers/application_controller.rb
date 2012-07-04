class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user,
                :authorise,
                :authorise_action?,
                :paginate_at,
                :clear_booking_vars
                
  before_filter :authorise
  
  # This is my 'Test' method. Can be accessed via a GET request to /test URL.
  def test 
   Email.booking_deleted_by_admin(Booking.last, '1').deliver
    
   redirect_to root_url
  end
  
  protected
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def authorise
    unless current_user
      redirect_to sign_in_path, notice: t('flash.please_sign_in') # FIXME: Turn 'Sign In' and 'Register' into clickable links and move the text out of the controller and into internationalisation file
    end
  end

  def authorise_action?(user_id)
    return true if user_id == current_user.id or current_user.admin?
  end
  
  def paginate_at
    return 10
  end
  
  def clear_booking_vars
    session[:current_step] = session[:booking_params] = session[:booking_step] = nil
  end
  

  
  
end
