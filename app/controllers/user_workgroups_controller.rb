class UserWorkgroupsController < ApplicationController
  before_action :auth

  def create
    @userWorkgroup = UserWorkgroup.new(user_workgroup_params)
    notice_msg= '';

    if @userWorkgroup.save
      notice_msg = 'Personal har registrerats till arbetsgruppen.'
    else
      p notice_msg = 'Personal kunde inte registreras.'
      p @userWorkgroup.errors.inspect
    end

    respond_to do |format|
      format.html { redirect_to workgroup_path(@userWorkgroup.workgroup_id), notice: notice_msg }
    end
  end

  def destroy
    UserWorkgroup.find(params[:id]).destroy
    respond_to do |format|
       format.html { redirect_to(:back)  }
       format.json { head :no_content }
    end
  end

  private

    def user_workgroup_params
      params.require(:user_workgroup).permit(:workgroup_id, :user_id)
    end

    def auth
      if session[:user_id] == nil
        redirect_to root_url, notice: 'Du måste logga in med ditt Google konto för att använda applikationen!'
      elsif current_user.user_type != 'principal'
        redirect_to root_url, notice: 'Bara rektorer kan editera arbetsgrupper.'
      elsif current_user.schools.empty?
        redirect_to root_url, notice: 'Du är inte registrerad till enn skola, be administratören registrera dig.'
      end
    end
end
