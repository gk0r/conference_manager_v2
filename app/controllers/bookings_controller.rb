class BookingsController < ApplicationController

  # GET /bookings
  # GET /bookings.json
  def index
    @bookings = Booking.where("date > ?", Date.yesterday).paginate  page: params[:page], 
                                                  order: 'date, time_start asc',
                                                  per_page: paginate_at()

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @booking }
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
    @booking = Booking.new(params[:booking])
    
    user_interaction('new')
  end

  # PUT /bookings/1
  # PUT /bookings/1.json
  def update
    @booking = Booking.find(params[:id])
    @booking.attributes = params[:booking]
    
    user_interaction('edit')
  end 

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy if authorise_action?(@booking.user.id)

    respond_to do |format|
      format.html { redirect_to my_path }#bookings_url }
      format.json { head :no_content }
    end
  end
  
  def user_interaction(mode)
    # Accepted 'mode' values:
    #   new   - Renders new action
    #   edit  - Renders edit action
    
    @booking.current_step = session[:current_step] if session[:current_step].present?
    @booking.user_id = current_user.id
    
    if params[:cancel_this_booking]
      @booking.destroy if authorise_action?(@booking.user.id)
      redirect_to clear_booking_steps_url
      
    elsif params[:reschedule]
      session[:current_step] = @booking.previous_step
      render mode
      
    elsif @booking.valid? 
      if @booking.first_step?
        # Call @booking.check_availability when running in the 'new' mode, otherwise default to @booking.reschedule_availability
        (mode == 'new') ? @conference_numbers = @booking.check_availability : @conference_numbers = @booking.reschedule_availability
        
        if @conference_numbers.empty?
          flash[:error] = t('booking.no_conference_numbers_are_available')
        else
          session[:current_step] = @booking.next_step
        end
        render mode
      
      elsif @booking.last_step?
        clear_booking_vars # Cledaring session variables related to this booking. Irrespective of whether we are able to save the model, or encounter an error, we can't use this data and therefore should dump it.
        if @booking.save
          flash[:notice] = t('booking.made')
          redirect_to my_path
        else
          flash[:error] = t('booking.error')
          render mode
        end
      end      
    
    else # This is for when the model is not valid
      render mode
    end
  end
  
end # End of controller
