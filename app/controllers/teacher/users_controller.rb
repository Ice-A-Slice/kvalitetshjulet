class Teacher::UsersController < ApplicationController
  before_action :auth
  before_action :set_user, only: [:show, :edit, :update]
  # Index function which list all teachers in the system
  def index
    @users = User.where(:user_type=>"teacher")
  end

  # Show function rails standard
  def show

    @hl = HighLight.where(user_id: @user.id)
    @color = ['','red','yellow','green']
    @color_swedish = ['','Hög','Normal','Låg']
  end

  # new function rails standard
  def new
    @user = User.new
  end

  def import
    if params[:file].present?
      result = User.import(params[:file])
      if result
        if result[1][:error].present?
          redirect_to teacher_users_path, error: result[1][:error]
        else
          redirect_to teacher_users_path, notice: 'Importering klar'
        end
      else
        redirect_to teacher_users_path, error: ['Det här filformatet stöds inte, eller har du inte valt någon fil']
      end
    else
      redirect_to teacher_users_path, error: ['Du måste välja en fil']
    end
  end

  # edit function rails standard
  def edit
  end

  # update function renders out show action because of difficulties with namespacing conventions
  def update
    respond_to do |format|
      if @user.update(user_params)
        if current_user.user_type != "teacher"
        format.html { redirect_to teacher_users_path, notice: 'Personal har Uppdaterats.' }
        else
          format.html { redirect_to teacher_user_path(current_user), notice: 'Din profil har Uppdaterats.' }
        end
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
        format.html { redirect_to teacher_users_path, notice: 'Ny Personal har skapats.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy 
    
   User.find(params[:id]).destroy 
   @asset_id = params[:id]
    #@user.destroy
    respond_to do |format|
      format.html { redirect_to teacher_users_path, notice: "Personal har tagits bort!" } 
      format.js 
    end

  # destroy function rails standard
  # def destroy
  #   @user.destroy
  #    @asset_id = params[:id]
  #   respond_to do |format|
  #     format.html { redirect_to teacher_users_url }
  #     format.json { head :no_content }
  #     format.js
  #   end
  end

  private
  # If a user exists things will go fine! Else.. Render nothing! -->
 # def set_user
   # if User.exists?(params[:id])
   #   @user = User.find(params[:id])
   # else
    #  render :text => "Användaren kan ej hittas!"
    #end
  #end
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :user_type, :email_confirmation)
  end
  
  #Checks your permissions.
  def auth
    if session[:user_type].to_s == "principal" || session[:user_type].to_s == "admin" || session[:user_type].to_s == "teacher"
    else
      render :text => "Du har inte behörighet att visa sidan!"
    end
  end
end

#--> Review by Niklas 10:30 27/3-14
