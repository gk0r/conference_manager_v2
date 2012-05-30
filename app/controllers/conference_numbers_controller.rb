class ConferenceNumbersController < ApplicationController
  # GET /conference_numbers
  # GET /conference_numbers.json
  def index
    @conference_numbers = ConferenceNumber.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @conference_numbers }
    end
  end

  # GET /conference_numbers/1
  # GET /conference_numbers/1.json
  def show
    @conference_number = ConferenceNumber.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @conference_number }
    end
  end

  # GET /conference_numbers/new
  # GET /conference_numbers/new.json
  def new
    @conference_number = ConferenceNumber.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @conference_number }
    end
  end

  # GET /conference_numbers/1/edit
  def edit
    @conference_number = ConferenceNumber.find(params[:id])
  end

  # POST /conference_numbers
  # POST /conference_numbers.json
  def create
    @conference_number = ConferenceNumber.new(params[:conference_number])

    respond_to do |format|
      if @conference_number.save
        format.html { redirect_to conference_numbers_path, notice: "Conference number #{@conference_number.conference_number} was successfully created." }
        format.json { render json: @conference_number, status: :created, location: @conference_number }
      else
        format.html { render action: "new" }
        format.json { render json: @conference_number.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /conference_numbers/1
  # PUT /conference_numbers/1.json
  def update
    @conference_number = ConferenceNumber.find(params[:id])

    respond_to do |format|
      if @conference_number.update_attributes(params[:conference_number])
        format.html { redirect_to conference_numbers_path, notice: "Conference #{@conference_number.conference_number} number was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @conference_number.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conference_numbers/1
  # DELETE /conference_numbers/1.json
  def destroy
    @conference_number = ConferenceNumber.find(params[:id])
    @conference_number.destroy if current_user.admin?

    respond_to do |format|
      format.html { redirect_to conference_numbers_url }
      format.json { head :no_content }
    end
  end
end
