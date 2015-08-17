class SchoolsController < ApplicationController
  before_action :auth
  before_action :set_school, only: [:show, :edit, :update, :destroy]


  # GET /schools
  # GET /schools.json
  def index
    @schools = School.all

  end

  # GET /schools/1
  # GET /schools/1.json
  def show
    @principals = User.where(:user_type => "principal")
    @teachers = User.where(:user_type => "teacher")
    @activePrincipals = SchoolUser.all
    @activeTeachers = SchoolUser.all

  end

  # GET /schools/new
  def new

    if current_user.user_type == "admin"
      @school = School.new
    else
      render :text => "Du har inte behörighet att visa sidan!"
    end

  end

  # GET /schools/1/edit
  def edit
  end

  # POST /schools
  # POST /schools.json
  def create
    @school = School.new(school_params)
    respond_to do |format|
      if @school.save
        format.html { redirect_to @school, notice: 'Skolan har skapats!' }
        format.json { render action: 'show', status: :created, location: @school }
      else
        format.html { render action: 'new' }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /schools/1
  # PATCH/PUT /schools/1.json
  def update
    respond_to do |format|
      if @school.update(school_params)
        format.html { redirect_to @school, notice: 'Skolan har uppdaterats!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_teacher
    @school = School.find(params[:school_id])
    @teachers = User.where(:user_type=>"teacher")
    @hideTeacher = Array.new
    @showTeacher = Array.new
  end

  def add_principal
    @school = School.find(params[:school_id])
    @users = User.where(:user_type=>"principal")
    @hidePrincipal = Array.new
    @showPrincipal = Array.new
  end

  def add
    respond_to do |format|
      format.html { redirect_to(:back)}
      format.json { head :no_content }
    end
  end


  # DELETE /schools/1
  # DELETE /schools/1.json
  def destroy
    School.find(params[:id]).destroy 
    @asset_id = params[:id]
    #@user.destroy
    respond_to do |format|
      format.html { redirect_to schools_path, notice: "Skolan har tagits bort!" } 
      format.js 
    end
    # destroy funktionen utan ajax
    # @school.destroy
    # respond_to do |format|
    #   format.html { redirect_to schools_url }
    #   format.json { head :no_content }
    # end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_school
    @school = School.find(params[:id])
  end


  #Require params for schools.
  def school_params
    params.require(:school).permit(:name, :district, :file, :remove_file)
  end

  #Checks your permissions.
  def auth
    if session[:user_id] != nil
    else
      redirect_to root_url, notice: "Du måste logga in med ditt google konto för att använda applikationen!"
    end
  end

end

#--> Review by Niklas 10:30 27/3-14