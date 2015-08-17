class WorkgroupsController < ApplicationController
  before_action :auth #authenticate
  before_action :set_workgroup, only: [:show, :edit, :update, :destroy, :add_user]

  # GET /workgroups
  # GET /workgroups.json
  def index
    @workgroups = []
    current_user.schools.each do |s|
      s.workgroups.each do |w|
        @workgroups.push(w)
      end
    end
  end

  # GET /workgroups/1
  # GET /workgroups/1.json
  def show
    @usersInWorkgroup = @workgroup.users
    @allUsersInWorkgroup = @workgroup.user_workgroups
  end

  # GET /workgroups/new
  def new
    @workgroup = Workgroup.new
  end

  # GET /workgroups/1/edit
  def edit
  end

  # POST /workgroups
  # POST /workgroups.json
  def create
    @workgroup = Workgroup.new(workgroup_params)

    respond_to do |format|
      if @workgroup.save
        format.html { redirect_to workgroups_path, notice: 'Arbetsgruppen har skapats.' }
        format.json { render action: 'show', status: :created, location: @workgroup }
      else
        format.html { render action: 'new' }
        format.json { render json: @workgroup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /workgroups/1
  # PATCH/PUT /workgroups/1.json
  def update
    respond_to do |format|
      if @workgroup.update(workgroup_params)
        format.html { redirect_to @workgroup, notice: 'Arbetsgruppen uppdaterades.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @workgroup.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_user
    @userWorkgroup = UserWorkgroup.new()

    # Does not include users that already is in the workgroup
    @users = @workgroup.school.users.reject{ |u| @workgroup.users.include? u }
  end

  # DELETE /workgroups/1
  # DELETE /workgroups/1.json
  def destroy
    @workgroup.destroy
    respond_to do |format|
      format.html { redirect_to workgroups_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workgroup
      @workgroup = params.has_key?(:workgroup_id) ? Workgroup.find(params[:workgroup_id]) : Workgroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def workgroup_params
      params.require(:workgroup).permit(:name, :school_id)
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
