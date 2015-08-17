class HighLightsController < ApplicationController
  #----> Controller is used by Ajax and does not totally respond to the Rails 4.2 convention.
  before_action :auth
  before_action :set_high_light, only: [:show, :edit, :update, :destroy]


  # GET /high_lights
  # GET /high_lights.json

  #-----> Can't touch this! To many things involved. //Niklas
  def index
     @high_lights = HighLight.all
     highlights = HighLight.where('user_id' => session[:user_id])
     events = Event.all
    json = {:events => events, :highlights => highlights }.to_json
    respond_to do |format|
      format.html { }
      format.json { render :json => json }
    end
  end
  #----->

  # GET /high_lights/1
  # GET /high_lights/1.json
  def show
  end

  # GET /high_lights/new
  def new
    @high_light = HighLight.new
  end

  # GET /high_lights/1/edit
  def edit
  end

  # POST /high_lights
  # POST /high_lights.json
  def create
    @high_light = HighLight.new(high_light_params)
    respond_to do |format|
      if @high_light.save
        @week = @high_light.week
        colors = ['', 'red', 'yellow', 'green']
        @color = colors[@high_light.color]
        @high_lights = HighLight.where('id' => @high_light.id)
        format.html { redirect_to @high_light, notice: 'Veckobelastning har skapats!' }
        format.json { render action: 'show', status: :created, location: @high_light }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @high_light.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /high_lights/1
  # PATCH/PUT /high_lights/1.json
  def update
    @high_lights = HighLight.where('id' => params[:id])
    respond_to do |format|
      if @high_light.update(high_light_params)
        format.html { redirect_to @high_light, notice: 'Veckobelastning har uppdaterats!' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @high_light.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /high_lights/1
  # DELETE /high_lights/1.json
  def destroy
    output = @high_light.to_json
    @high_light.destroy
    respond_to do |format|
      format.html { redirect_to high_lights_url, notice: 'Veckobelastning har tagits bort!' }
      format.json { render :json => output }
      format.js
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_high_light
    @high_light = HighLight.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def high_light_params
     params.require(:high_light).permit(:week, :year, :color, :comment, :user_id)
  end

  #Checks your permissions
  def auth
    if session[:user_id] != nil
    else
      redirect_to root_url, notice: "Du måste logga in med ditt google konto för att använda applikationen!"
    end
  end
end


#--> Review by Niklas 10:30 27/3-14