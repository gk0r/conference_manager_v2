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
    @booking = Booking.new(params[:booking])
    @booking.current_step = session[:current_step] if session[:current_step].present?
    @booking.user_id = current_user.id
    
    if params[:cancel]
      @booking.destroy
      redirect_to clear_booking_steps_url
      
    elsif @booking.valid? 
      if @booking.first_step?
        @conference_numbers = @booking.check_availability
        if @conference_numbers.empty?
          flash[:error] = "No conference numbers are available at the time you have chosen"
        else
          session[:current_step] = @booking.next_step
        end
        render "new"
      
      elsif @booking.last_step?
        clear_booking_vars # Cledaring session variables related to this booking. Irrespective of whether we are able to save the model, or encounter an error, we can't use this data and therefore should dump it.
        if @booking.save
          flash[:notice] = 'Booking made'
          redirect_to my_path
        else
          flash[:error] = 'ERROR: an error occured whilst making this booking, please try again.'
          render 'new'
        end
      end      
    
    else # This is for when the model is not valid
      render 'new'
    end
    
  end

  # PUT /bookings/1
  # PUT /bookings/1.json
  def update
    
    @booking = Booking.find(params[:id])
    @booking.current_step = session[:current_step] if session[:current_step].present?
    @booking.attributes = params[:booking]
    @booking.user_id = current_user.id
    
    if params[:cancel]
      @booking.destroy
      redirect_to clear_booking_steps_url
      
    elsif @booking.valid? 
      if @booking.first_step?
        @conference_numbers = @booking.reschedule_availability
        if @conference_numbers.empty?
          flash[:error] = 'No conference numbers are available at the time you have chosen'
        else
          session[:current_step] = @booking.next_step
        end
        render "edit"
      
      elsif @booking.last_step?
        clear_booking_vars # Cledaring session variables related to this booking. Irrespective of whether we are able to save the model, or encountered an error, we can't use this data and therefore should dump it.
        if @booking.save
          flash[:notice] = 'Booking made'
          redirect_to my_path
        else
          flash[:error] = 'ERROR: an error occured whilst making this booking, please try again.'
          render 'new'
        end
      end      
    
    else # This is for when the model is not valid
      render 'edit'
    end
    
  end # End of UPDATE action

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy if authorise_action?(@booking.user.id)

    respond_to do |format|
      format.html { redirect_to :back }#bookings_url }
      format.json { head :no_content }
    end
  end
  
end # End of controller
