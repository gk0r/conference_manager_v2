class BookingsController < ApplicationController

  # GET /bookings
  # GET /bookings.json
  def index
    @bookings = Booking.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bookings }
    end
  end  
  
  # GET /bookings/my
  # GET /bookings/my.json
  def my_index
    @bookings = Booking.where("date > ? and user_id == ?", 
     Date.yesterday(), current_user.id).paginate page: params[:page], 
      order: 'created_at asc',
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
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @booking }
    end 
  end

  # GET /bookings/1/edit
  def edit
    @booking = Booking.find(params[:id])
    clear_booking_vars
  end

  # POST /bookings
  # POST /bookings.json
  def create
    session[:booking_params] = Hash.new unless session[:booking_params] # Initialise the Hash to avoid unknown method deep_merge! exception
    session[:booking_params].deep_merge!(params[:booking]) if params[:booking]
    
    @booking = Booking.new(session[:booking_params])
    @booking.parse?(current_user.id)
    @booking.current_step = session[:booking_step] if session[:booking_step] # Hmm - what's this?
    
    # Navigate to Previous Step when the user clicks Reschedule button
    if params[:cancel]
      @booking = nil
    elsif params[:reschedule]
      @booking.previous_step
    elsif @booking.valid?
      if @booking.last_step?
        @booking.save
      else
        @booking.next_step
      end
    end

    session[:booking_step] = @booking.current_step unless params[:cancel]
    get_available_conference_numbers #unless params[:cancel]
    
    # Redirects and Renders
    if params[:cancel]
      redirect_to clear_booking_steps_url
    elsif @booking.new_record?
      render action: "new"
    else
      clear_booking_vars
      flash[:notice] = "Booking Made !"
      redirect_to bookings_path
    end
    
  end

  # PUT /bookings/1
  # PUT /bookings/1.json
  def update
    # 
    # This is my work in progress logic
    # 
    @booking = Booking.find(params[:id])
    @booking.parse?(current_user.id) # Parse the model attributes (specifically the time_start and time_finish that has date attributes)
    @booking.current_step = session[:booking_step] # Retrieve the current step from the session hash. This is updated further on.
    
    if params[:cancel]
      # Cancel button
      clear_booking_vars
      redirect_to root_url
    elsif @booking.update_attributes(params[:booking]) and @booking.valid? and @booking.last_step? 
      # The model is valid and we're ready to store it
      clear_booking_vars
      redirect_to bookings_path, notice: t('booking.updated')
    elsif @booking.valid? 
      # Model is valid but we're not at the end yet, go to the next step
      @booking.next_step
      session[:booking_step] = @booking.current_step
      render action: "edit"
    else 
      # Model is not valid. Re-enter attributes for another attempt at validation
      render action: "edit"
    end
    
  end # End of UPDATE action

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy

    respond_to do |format|
      format.html { redirect_to bookings_url }
      format.json { head :no_content }
    end
  end
  
  # GET /bookings/check_availability
  def get_available_conference_numbers # TODO: Does this belong in the controller or the model?
    @conference_numbers = ConferenceNumber.find_by_sql(
      ["SELECT id, conference_number 
        FROM conference_numbers 
        WHERE id NOT IN 
          (SELECT conference_numbers.id 
            FROM conference_numbers 
            INNER JOIN bookings 
            ON conference_numbers.id=bookings.conference_number_id 
            WHERE (bookings.time_start BETWEEN ? AND ?) 
            OR (bookings.time_finish BETWEEN ? AND ?)
          )",       
      @booking.time_start , 
      @booking.time_finish - 1.second, 
      @booking.time_start + 1.second, 
      @booking.time_finish])
    
  end # End of check_availability

end # End of controller
