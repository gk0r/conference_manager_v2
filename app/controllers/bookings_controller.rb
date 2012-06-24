class BookingsController < ApplicationController

  # GET /bookings
  # GET /bookings.json
  def index
    @bookings = Booking.where("date > ?", Date.yesterday).paginate  page: params[:page], 
                                                  order: 'date, time_start asc',
                                                  per_page: paginate_at()

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bookings }
    end
  end  
  
  # GET /bookings/my
  # GET /bookings/my.json
  def my_index
    @bookings = Booking.where("date > ? and user_id == ?", 
     Date.yesterday(), current_user.id).paginate  page: params[:page], 
                                                  order: 'date, time_start asc',
                                                  per_page: paginate_at()
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bookings }
    end
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
    @booking = Booking.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @booking }
    end
  end

  # GET /bookings/new
  # GET /bookings/new.json
  def new
    @booking = Booking.new
    clear_booking_vars
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @booking }
    end 
  end

  # GET /bookings/1/edit
  def edit
    @booking = Booking.find(params[:id])
    clear_booking_vars # This ensures that every time we receive GET request for EDIT action we start from scratch in session variables
  end

  # POST /bookings
  # POST /bookings.json
  def create
    session[:booking_params] = Hash.new unless session[:booking_params] # Initialise the Hash to avoid unknown method deep_merge! exception
    session[:booking_params].deep_merge!(params[:booking]) if params[:booking]
    #session[:booking_params] : params[:booking] # Not sure what I was trying to do here...
    
    @booking = Booking.new(session[:booking_params])
    @booking.parse(current_user.id)
    @booking.current_step = session[:booking_step] if session[:booking_step]

    if params[:cancel]
      @booking.destroy
      redirect_to clear_booking_steps_url

    elsif params[:reschedule]
      session[:booking_step] = @booking.previous_step
      render "new"

    elsif @booking.valid? and @booking.first_step?
      @conference_numbers = @booking.check_availability
      if @conference_numbers.empty?
        session[:booking_step] = @booking.previous_step
        flash[:error] = "No conference numbers available at the time you have chosen, please reschedule"
      else
        session[:booking_step] = @booking.next_step
      end
      render "new"

    elsif @booking.valid? and @booking.last_step?
      # Booking is valid and on the last_step. Save the model and return back to the main page.
      @booking.save
      clear_booking_vars
      flash[:notice] = "Booking Made !"
      redirect_to my_path
      Email.booking_created(current_user, @booking).deliver
    else
      # This is for when the model is not valid
      render "new"
    end

  end

  # PUT /bookings/1
  # PUT /bookings/1.json
  def update
    # Developer Notes: I need a session hash here to keep track of the @booking.time_start and @booking.time_finish. For some reason
    # Rails does not process form fields that disabled. In order to overcome this, I have to store this information inside the session.
    session[:booking_params] = Hash.new unless session[:booking_params] # Initialise the Hash to avoid unknown method deep_merge! exception
    session[:booking_params].deep_merge!(params[:booking]) if params[:booking]

    @booking = Booking.find(params[:id])  
    # Do I need the line below in the UPDATE scenario?
    @booking.parse(current_user.id) # Parse the model attributes (specifically the time_start and time_finish that has date attributes)
    @booking.current_step = session[:booking_step] # Retrieve the current step from the session hash. This is updated further on.
    @booking.attributes = session[:booking_params]

    if params[:cancel]
      # Cancel button
      clear_booking_vars
      redirect_to root_url
      
    elsif params[:reschedule]
      session[:booking_step] = @booking.previous_step
      render "edit"
      
    elsif @booking.valid? and @booking.first_step?
      @conference_numbers = @booking.check_availability
      if @conference_numbers.empty?
        session[:booking_step] = @booking.previous_step
        flash[:error] = "No conference numbers available at the time you have chosen, please reschedule"
      else
        session[:booking_step] = @booking.next_step
      end
      render "edit"

    elsif @booking.valid? and @booking.last_step? #and @booking.update_attributes(params[:booking])
      @booking.save
      clear_booking_vars
      flash[:notice] = "Booking updated!"
      redirect_to my_path
      Email.booking_created(current_user, @booking).deliver
    else
      # This is for when the model is not valid
      render "edit"
    end
    
  end # End of UPDATE action

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking = Booking.find(params[:id])
    if authorise_action?(@booking.user.id)
      Email.booking_deleted(current_user, @booking, current_user).deliver
      @booking.destroy
    end

    respond_to do |format|
      format.html { redirect_to :back }#bookings_url }
      format.json { head :no_content }
    end
  end
  
end # End of controller
