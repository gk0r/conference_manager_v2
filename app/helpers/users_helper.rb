module UsersHelper
  
  def password_hint
    if controller.action_name == "update" || controller.action_name == "edit" # Request the user to re-enter their password when they update their profile
      "Please re-enter your password if you update your profile" # Should this be "Please leave this field empty if you do not wish to change your password?"
    else # Assume new action, and anything else...
      "Please create a new password"
    end
  end

  def username_change?
    if controller.action_name == "new" || controller.action_name == "create" # Allow the user to register as anyone, but do not allow them to change it after registration.
      return false
    else # Do not allow the user to change their username after they have registered.
      return true
    end
  end  
  
  def username_change_hint
    if username_change?
      "You can not change your username after you have registered"
    else
      "Please enter your DHS Logon ID"
    end
  end
  
  def authorise_action(user_id)
    @user_id = user_id
    
    if @user_id == current_user.id or current_user.admin?
           return true
    else
           return false
    end
  
  end
  
  
end # End of User Helper class
