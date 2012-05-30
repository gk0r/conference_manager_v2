class UsersController < ApplicationController
  skip_before_filter :authorise, only: [:new, :create]
  
  # GET /users
  # GET /users.json
  def index
    if current_user.admin? # Only Admin users can view etails of registered users. 
      @users = User.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @users }
      end
    else
      redirect_to root_url # Everyone else is redirected to root_url
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(current_user.id) # Only allow users to update their own profiles
    @user = User.find(params[:id]) if current_user.admin? and params[:id] # Admins can update anything
  end

  # POST /users
  # POST /users.json
  def create
    logger.debug "!! Inside the CREATE action of the USERS controller"
    @user = User.new(params[:user])
    logger.debug "!! @user.role.to_sym [Create] = #{@user.role.to_sym}"

    respond_to do |format|
      if @user.save
        logger.debug "!! @user = #{@user}"
        session[:user_id] = @user.id # Log the current user in upon successful registration
        format.html { redirect_to root_url, notice: "#{@user.first_name} #{@user.last_name} was successfully added." }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    logger.debug "!! current_user.role.to_sym = #{current_user.role.to_sym}"

    respond_to do |format|
      if @user.update_attributes(params[:user], :as => current_user.role.to_sym )
        format.html { redirect_to users_path, notice: "#{@user.first_name} #{@user.last_name}'s account was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy if current_user.admin?

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
