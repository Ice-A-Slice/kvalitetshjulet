class EventsController < ApplicationController
  before_action :auth #authenticate
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.by_year(session[:year_selected]).all

  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new 
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json

  def create
    new_params = event_params
    if new_params.has_key?(:workgroup)
      new_params.delete(:workgroup)
    end
    @event = Event.new(new_params)
    @event.dot_color = @event.event_type.color;
    respond_to do |format|
      if @event.save
        @adminOnJuror = ''
        if @event.user_id.present? and @event.school_id.present? and current_user.user_type == 'admin'
          @adminOnJuror = 'juror';
        end
        @events = Event.where('id' => @event.id)
        if @event.user_id?
          @owner = User.find(@event.user_id)
        else
          @owner = School.find(@event.school_id)
        end
        if event_params.has_key?(:workgroup) 
          EventWorkgroup.create(event_id: @event.id, workgroup_id: event_params.require(:workgroup))
        end
        format.html { redirect_to @event, notice: 'Händelsen har skapats!' }
        format.json { render action: 'show', status: :created, location: @event }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
    Rails.logger.info(@event.errors.inspect) 
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    # @events = Event.find(params[:id])
    if @event.user_id.present?
      @user = User.find(@event.user_id)
    else
      @user = current_user
    end
    @pre_color = @event.event_type.present? ? @event.event_type.color : @event.dot_color

    new_params = event_params
    if new_params.has_key?(:workgroup)
      new_params.delete(:workgroup)
    end
    
    @old_title = @event.title
    
    new_params[:dot_color] = EventType.find(new_params[:type_id]).color;

    respond_to do |format|
      if @event.update(new_params)
        @adminOnJuror = ''
        if @event.user_id.present? and @event.school_id.present? and current_user.user_type == 'admin'
          @adminOnJuror = 'juror';
        end
        if @event.user_id?
          @owner = User.find(@event.user_id)
        else
          @owner = School.find(@event.school_id)
        end
        if event_params.has_key?(:workgroup)
          @event.event_workgroup.update(workgroup: Workgroup.find(event_params[:workgroup]));
        end
        format.html { redirect_to @event, notice: 'Händelsen har uppdaterats!' }
        format.json { head :no_content } 
        format.js 
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    output = @event.to_json
    @color = @event.event_type.present? ? @event.event_type.color : @event.dot_color
    @ringName = (@event.school_id.present? and @event.user_id.present?) ? 'juror' : ''
    p @ringName
    p @ringName
    p @ringName
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Händelsen har tagits bort!' }
      format.json { render :json => output }
      format.js
    end

  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
     @event = Event.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:title, :comment, :datetime, :user_id, :school_id, :week, :file, :type_id, :ring_name, :workgroup)
  end

  # checks your permissions
  def auth
    if session[:user_id] == nil
       redirect_to root_url, notice: "Du måste logga in med ditt google konto för att använda applikationen!"
    end
  end
end


#--> Review by Niklas 10:30 27/3-14
