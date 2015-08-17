class Principal::UsersController < ApplicationController
  before_action :auth #Authenticate
  before_action :set_user, only: [:show, :edit, :update, :destroy]


  # Index function which list all principals in the system
  def index
    @users = User.where(user_type: :principal)
  end

  # Show function rails standard
  def show
    @user = User.find(params[:id])
    @schoolUsers = SchoolUser.all
    @events = Event.all(:order => 'school_id, week, datetime')
    @schools = School.all
    @principals = User.where(:user_type => "principal")
    @teachers = User.where(:user_type => "teacher")
 
  end

  # new function rails standard
  def new
    @user = User.new
  end

  # edit function rails standard
  def edit
  end

  # update function renders out show action because of difficulties with namespacing conventions
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to principal_user_path, notice: 'Rektor har uppdaterats.'}
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # create function renders out show action because of difficulties with namespacing conventions
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to principal_users_path, notice: 'Ny Rektor har skapats.' }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # destroy function rails standard
  # Method is called with Ajax and is not using strong params.
  def destroy
    User.find(params[:id]).destroy 
    @asset_id = params[:id]
    #@user.destroy
    respond_to do |format|
      format.html { redirect_to principal_users_path, notice: "Rektor har tagits bort!" } 
      format.js 
    end
  end

  private
  # If a user exists things will go fine! Else.. Render nothing! -->
  def set_user
    if User.exists?(params[:id])
      @user = User.find(params[:id])
    else
      render :text => "Användaren kan ej hittas!"
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :user_type, :email_confirmation)
  end

  #Method that checks your permissions.
  def auth
    if session[:user_id] != nil

    else
      redirect_to root_url, notice: "Du måste logga in med ditt google konto för att använda applikationen!"
    end
  end

  #Checks your permissions.
  def auth
    if session[:user_type].to_s == "admin" || session[:user_type].to_s == "principal"
    else
      render :text => "Du har inte behörighet att visa sidan!"
    end
  end
end


#--> Review by Niklas 10:30 27/3-14
