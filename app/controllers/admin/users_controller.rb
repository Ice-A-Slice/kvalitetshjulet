  class Admin::UsersController < ApplicationController
  before_action :auth #Authentication
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  #A method for listing all the admins. To be used as a help-method
  def index
    @users = User.where(user_type: :admin)
  end

  #A method that renders a form that can create a new admin.
  def new
    @user = User.new
  end

  #The method that CREATES a news Admin.
  def create
    @user = User.new(user_params)
    if@user.save
      respond_to do |format|
        format.html { redirect_to admin_users_path, notice: 'Ny Admin har skapats.' }
      end
    else
      render text: "Användaren kunde ej skapas!"
    end
  end

  #A method that shows a new Admin.
  def show

    @eventsForAdmin = User.find(session[:user_id])
    @event = Event.where(user_id: session[:user_id])
   
  end

  #Destroy a user object.
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_path, notice: 'Användaren har tagits bort!' }
    end
  end

  #A method for edit an userobject.
  def edit
  end

  #Update method for userobject.
  def update
    if @user.update(user_params)
      respond_to do |format|
         format.html { redirect_to admin_user_path, notice: 'Admin har uppdaterats.' }
      end
    else
       render text: "Något gick fel!"
    end
  end

  #Private scope ->
  private

  #If a user exists things will go fine! Else.. Render nothing! -->
  def set_user
    if User.exists?(params[:id])
        @user = User.find(params[:id])
    else
      render text: "Användaren kan inte hittas!"
    end
  end

  #Method for permitting params to this controller.
  def user_params
    params.require(:user).permit(:id, :name, :email, :user_type)
  end

  #Checks your permissions. 
  def auth
      if session[:user_type].to_s == "admin"
      else
        render :text => "Du har inte behörighet att visa sidan!"
      end
  end
end


#--> Review by Niklas 10:30 27/3-14
