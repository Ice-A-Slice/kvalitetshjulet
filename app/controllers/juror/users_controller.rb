class Juror::UsersController < ApplicationController
  before_action :auth
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # Index function which list all jurors in the system
  def index
      @users = User.where(user_type: :juror)
  end

  # Show function rails standard
  def show
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
      format.html { redirect_to juror_users_url, notice: 'Nämdeman har uppdaterats.'  }
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
        format.html { redirect_to juror_users_path, notice: 'Ny Nämdeman har skapats.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # destroy function rails standard
  def destroy
    User.find(params[:id]).destroy 
    @asset_id = params[:id]
    #@user.destroy

    respond_to do |format|
      format.html { redirect_to juror_users_path, notice: "Användaren har tagits bort!" } 
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
    params.require(:user).permit(:name, :email, :email_confirmation, :user_type)
  end

  #Checks your permissions.
  def auth
    if session[:user_type].to_s == "juror" || session[:user_type].to_s == "admin"
    else
      render :text => "Du har inte behörighet att visa sidan!"
    end
  end
end

#--> Review by Niklas 10:30 27/3-14
