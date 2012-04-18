module BookingsHelper
  
  # FIXME: Does this work? Where is the best place to book this sort of logic?
  # This helper method parses the Booking Object from the various forms.
  def parse_booking ()
      @booking.user_id = session[:user_id] 
      
      begin 
        @booking.date = Date.parse(params[:date])
      rescue
        @booking.date = nil
      end
      
      begin 
        @booking.time_start = Time.parse("#{@booking.date} #{Time.parse(params[:time_start])}")
      rescue
        @booking.time_start = nil
      end
          
      begin 
        @booking.time_finish = Time.parse("#{@booking.date} #{Time.parse(params[:time_finish])}")
      rescue
        @booking.time_finish = nil
      end
      
      begin 
        @booking.conference_number_id = params[:conference_number_id]
      rescue
        @booking.conference_number_id = nil
      end  
  end
  
end
