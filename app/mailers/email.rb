class Email < ActionMailer::Base
  default from: "username@example.com"
  
  def subject_prefix 
    "[Conference Manager] "
  end
  
  def welcome(user)
    @user = user
    
    mail  :to => @user.username.to_s + "@centrelink.gov.au",
          subject: subject_prefix + "Welcome !"
  end
  
  def user_registration(admin, user)
    @admin  = admin
    @user   = user
    
    mail  :to => @admin.username.to_s + "@centrelink.gov.au",
          subject: subject_prefix + "New user registered: " + @user.to_label
  end

  def user_deleted(admin, user, actioned_by)
    @admin = admin
    @user = user
    @actioned_by = actioned_by

    mail  :to => @admin.username.to_s + "@centrelink.gov.au",
          subject: subject_prefix + @user.to_label + "'s account deleted."
  end
  
  def conference_number_added(admin, conference_number, actioned_by)
    @admin = admin
    @conference_number = conference_number
    @actioned_by = actioned_by
    
    mail  :to => @admin.username.to_s + "@centrelink.gov.au",
          subject: subject_prefix + "New conference number added: " + @conference_number.conference_number
  end
  
  def conference_number_deleted(admin, conference_number, actioned_by)
    @admin = admin
    @conference_number = conference_number
    @actioned_by = actioned_by

    mail  :to => @admin.username.to_s + "@centrelink.gov.au",
          subject: subject_prefix + "Conference number removed: " + @conference_number.conference_number
  end
  
  def booking_created(user, booking)
    @user = user
    @booking = booking
    
    mail  :to => @user.username.to_s + "@centrelink.gov.au",
          subject: subject_prefix + " #{@booking.conference_number.conference_number} Booked 
            for #{@booking.date.strftime('%I:%M %p')} 
            from #{booking.time_start.strftime('%I:%M %p')} 
            until #{@booking.time_finish.strftime('%I:%M %p')}"
  end
  
  def booking_deleted(user, booking, actioned_by)
    @user = user
    @booking = booking
    @actioned_by = actioned_by
    
    mail  :to => @user.username.to_s + "@centrelink.gov.au",
          subject: subject_prefix + " Cancelled booking for #{@booking.conference_number.conference_number} 
            on #{@booking.date.strftime('%I:%M %p')} 
            from #{booking.time_start.strftime('%I:%M %p')} 
            until #{@booking.time_finish.strftime('%I:%M %p')}"
    
  end
    
end