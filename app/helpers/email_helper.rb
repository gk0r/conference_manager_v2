module EmailHelper
  
  # This helper compares the user for whom the email is intended with the user who performed a particular action. 
  # Where the two are identifical 'you' is returned. Where the two are different, the name of the 'actionee' is returned.
  def actionee_reference
    if @actioned_by.id == @booking.user.id
      return "You"
    else
      return @actioned_by.to_label
    end
  end
  
end