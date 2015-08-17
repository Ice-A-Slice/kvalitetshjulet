class EventTypesController < ApplicationController
  before_action :auth
  before_action :set_event_type, only: [:show, :edit, :update, :remove, :destroy]

  # GET /event_types
  # GET /event_types.json
  def index
    @event_types = EventType.all
  end

  # GET /event_types/1
  # GET /event_types/1.json
  def show
  end

  # GET /event_types/new
  def new
    @event_type = EventType.new
  end

  # GET /event_types/1/edit
  def edit
  end

  # POST /event_types
  # POST /event_types.json
  def create
    @event_type = EventType.new(event_type_params)

    respond_to do |format|
      if @event_type.save
        format.html { redirect_to event_types_url }
        format.json { render action: 'new', status: :created, location: @event_type }
      else
        format.html { render action: 'new' }
        format.json { render json: @event_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /event_types/1
  # PATCH/PUT /event_types/1.json
  def update
    respond_to do |format|
      if @event_type.update(event_type_params)
        format.html { redirect_to event_types_url }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def remove
    if EventType.count < 2
      redirect_to event_types_url, notice: "Det måste alltid finnas minst en aktivitetstyp" and return
    end

    @other_event_types = EventType.where.not(id: params[:id])
  end

  # DELETE /event_types/1
  # DELETE /event_types/1.json
  def destroy
    begin
      if params.has_key?(:event)
        @event_type.events.update_all(type_id: params[:event][:type_id])
      end

      if !@event_type.events.count.zero?
        redirect_to remove_event_type_url and return
      else
        @event_type.destroy        
      end
    rescue StandardError => e
      flash[:notice] = e.message
    end

    respond_to do |format|
      format.html { redirect_to event_types_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_type
      @event_type = EventType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_type_params
      params.require(:event_type).permit(:name, :color)
    end

    def auth      
      if session[:user_id] == nil
        redirect_to root_url, notice: "Du måste logga in med ditt google konto för att använda applikationen."
      elsif session[:user_type] != "admin"
        redirect_to root_url, notice: "Du har inte de nödvändiga rättigheterna för att kunna använda den delen av applikationen."
      end
    end
end
