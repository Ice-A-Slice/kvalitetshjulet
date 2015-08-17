class SchoolUsersController < ApplicationController
  #This class is not using the rails 4.2 convention. ----->
  before_action :auth
  before_action :set_school_user, only: [:destroy]


  #Method for creating a new activeprincipal.
  def new
    @schoolUser = SchoolUser.new
  end

  #Method for creating a new activeprincipal.
  def create
    @schoolUser = SchoolUser.new(school_user_params)

    if @schoolUser.save
      @urlfix = "/schools/" + @schoolUser.school_id.to_s #Fulfix OF DOOM!!!!! //Niklas.
      respond_to do |format|
        format.html { redirect_to @urlfix, notice: 'Personal har registrerats till skola' }
      end
    else
      @urlfix = "/schools/" + @schoolUser.school_id.to_s #Fulfix OF DOOM!!!!! //Niklas.
      redirect_to @urlfix, notice: 'Ingen personal har registrerats' 
    end
  end

  #Method for destroying an activeprincipal objekt.
  def destroy
     #SchoolUser.find(params[:id]).destroy
    #@asset_id = params[:id]
    #respond_to do |format|
      #format.html { redirect_to school_user(params[:id]), notice: "successfully removed user" }
      #format.html{ render :text => "Användaren är avregistrerad!" }
      #format.js
      @schoolUser.destroy
      respond_to do |format|
         format.html { redirect_to(:back)  }
         format.json { head :no_content }
      end
   end

    # @schoolUser.destroy
    # respond_to do |format|
    #   format.html { redirect_to(:back)  }
    #   format.json { head :no_content }
    #end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_school_user
    @schoolUser = SchoolUser.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def school_user_params
    params.require(:school_user).permit(:school_id, :user_id)
  end

  #Checks your permissions.
  def auth
    if session[:user_id] != nil
    else
      redirect_to root_url, notice: "Du måste logga in med ditt google konto för att använda applikationen!"
    end
  end


#--> Review by Niklas 10:30 27/3-14