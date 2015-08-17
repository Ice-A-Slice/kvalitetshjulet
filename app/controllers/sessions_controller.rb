class SessionsController < ApplicationController
  #-------------->
  #Class is the main provider of variables for the wheel. Class is a total mess. //Niklas
  #-------------->
  before_filter :set_gon

  #---------------------> Can't touch this! //Niklas
  def index
    @event = Event.new
    events = Event.by_year(session[:year_selected]).all
    if current_user.present?
      # Creates an object filled with 4 zero-filled arrays, each 52 long.
      # If there is 3 events at week 16 created by the principal, then the
      # return_events[principal][15] is going to have the value 3.
      return_events = {
        'admin'     => Array.new(52) { Array.new() },
        'juror'     => Array.new(52) { Array.new() },
        'principal' => Array.new(52) { Array.new() },
        'teacher'   => Array.new(52) { Array.new() },
      }

      events.each do |e|
        color = e.event_type.present? ? e.event_type.color : e.dot_color
        title = e.title
        if e.user_id.blank? and e.school_id.present? and current_user.schools.map{|a| a.id}.include? e.school_id and e.ring_name == 'principal'
          return_events[e.ring_name][e.week] << {color: color, title: title}
        elsif e.user_id.present? and e.school_id.blank? and e.ring_name == 'admin'
          return_events[e.ring_name][e.week] << {color: color, title: title}
        elsif e.user_id.present? and e.school_id.present?
          if e.ring_name == 'juror' or (e.ring_name == 'teacher' and current_user.user_type == 'teacher' and current_user.workgroups.include?(e.workgroup))
            return_events[e.ring_name][e.week] << {color: color, title: title}
          end
        end

      end

      ## This was part of an older version, displaying workload in the most inner ring
      # return_events['teacher'] = HighLight.where('user_id' => current_user.id)
      ##

      gon.school_events = return_events
      gon.current_user_type = current_user.user_type

      gon.year_selected = session[:year_selected]

    end
  end
  #------------------> Review.

  #Creates the session from google auth.
  def create
     user = User.from_omniauth(env["omniauth.auth"])
     if user.empty?
       redirect_to root_path, notice: "Du har inte behörighet att använda applikationen."
     else
        user.each do |u|
          if User.where(:email => u.email).exists?
            ourDb = User.where(:email => u.email).take
            session[:user_id] = ourDb.id
            session[:user_type] = ourDb.user_type
            session[:user_name] = ourDb.name
            session[:year_selected] = Date.today.year.to_s
            redirect_to root_url
          else
            render :text => "Du har inger roll tillägnad till dig, vänligen kontakta administratören."
          end
       end
     end
  end

  #Destroys the session.
  def destroy
    session.destroy
    session[:user_id] = nil
    session[:user_type] = nil
    session[:user_name] = nil
    session[:year_selected] = nil
    redirect_to root_path, notice: "Du har loggats ut!"
  end

  #The Json session method.
  def events
    event = Event.by_year(session[:year_selected]).all
    output = event.to_json
    render :json => output
  end

  def set_selected_year
    session[:year_selected] = params[:year]
    gon.year_selected = session[:year_selected].to_i
    redirect_to root_path
  end

  def show_week_events
    if params.has_key?(:type)
      all_events = Event.by_year(session[:year_selected]).where('week' => params[:id])
      if all_events.length === 0
        @week = params[:id]
        render :partial => 'events/no_events'
      else

        sel_events = []
        c_event = Event.by_year(session[:year_selected]).where('week' => params[:id]).first
        @event_user_id = c_event.user_id
        # @event_user_type = params[:type];

        # Checks if params[:type] is a number. If it is; it's a principal-event
        if params[:type].to_i.to_s == params[:type]
          sel_type = School.where('id' => params[:type])
          @event_user_type = 'principal'
          sel_events = all_events.where('ring_name' => 'principal').where('school_id' => params[:type])
        else
          sel_type = User.where('user_type' => params[:type])
          @event_user_type = params[:type]
          all_events.each do |event|

            ifNotTeacher = (event.user_id.present? and event.school_id.present? and params[:type] != 'admin' and params[:type] != 'teacher')
            ifTeacher = (current_user.user_type == 'teacher' and current_user.workgroups.include?(event.workgroup))
            
            if sel_type.map{|a| a.id}.include? event.user_id and event.school_id.blank?
              sel_events.push(event);
            elsif ifNotTeacher or ifTeacher
              if params[:type] == event.ring_name
                sel_events.push(event)
              end
            end
          end
        end

        @usersWithSameUsertypeAsCurrentUser = User.where('user_type' => current_user.user_type)
        @events = sel_events
        @week = params[:id].to_i
        render :partial => 'events/show'
      end
    else
      render :partial => 'events/show'
    end
  end

  def edit_week_event
    @event = Event.find(params[:id])
    @week = @event.week.to_i
    @current_ring = @event.ring_name
    @schoolId = @event.school_id
    @pre_color = @event.event_type.present? ? @event.event_type.color : @event.dot_color
    
    if @event.school_id == 0
       @current_ring = 'juror'
    end
    render :partial => 'events/wheel_form'
  end

  def new_week_event
    @schoolId = current_user.user_type == 'teacher' ? current_user.schools[0].id : nil
    @event = Event.new
    @week = params[:id].to_i
    @current_ring = params.has_key?(:type) ? params[:type] : 'teacher'
    render :partial => 'events/wheel_form'
  end

  def user
    user = User.find(params[:id])
    output = user.to_json
    render :json => output
  end

 def show_high_lights
    @week = params[:id].to_i+1
    @high_light = HighLight.where('week=? AND user_id=?', @week, current_user.id).first
    render :partial => 'high_lights/show' 
  end
  
  def new_high_lights
    @high_light = HighLight.new
    @week = params[:id]
    render :partial => 'high_lights/wheel_form'
  end

   def edit_high_lights
    @high_light = HighLight.find(params[:id])
    @week = @high_light.week.to_i+1
    render :partial => 'high_lights/wheel_form'
  end

  def show_specific_highlights
    highlights = HighLight.where('user_id' => params[:id])
    events = Event.all
    json = {:events => events, :highlights => highlights }.to_json
    render :json => json
  end

   def delete_file
    @event = Event.find(params[:id])
    @week = @event.week.to_i
    File.delete("#{Rails.root}"+"/public"+"#{@event.file.url}") 
  end

  private
  
  def set_gon #Can't touch this---->
    if current_user.present?
      gon.session_id = session[:user_id]
      gon.users = User.where{user_type != 'admin'}

      gon.school_image_url = ''
      if current_user.schools.count > 0
        schools_with_file = current_user.schools.where("file is NOT NULL and file != ''")
        gon.school_image_url = schools_with_file[rand(0..schools_with_file.count-1)].file.url if schools_with_file.count > 0
      end

      principal_schools = User.select("*").joins(:school_users).where(" user_type = 'principal' AND user_id = " + session[:user_id].to_s)
      sel_teachers = []
      principal_schools.each do |school|
        teachers  = User.select("*").joins(:school_users).where(" user_type = 'teacher' AND school_id = " +"#{school.school_id}")
        sel_teachers.push(teachers);
      end
      gon.teachers = sel_teachers
      user = User.find(session[:user_id])
      gon.c_user_type = user.user_type
      gon.current_schools = current_user.schools
      gon.event_types = EventType.all

      gon.year_selected = session[:year_selected] ? session[:year_selected] : Date.today.year

      p gon.year_selected
      p gon.year_selected
      p gon.year_selected
      p gon.year_selected
    end
  end
end


#--> Review by Niklas 10:30 27/3-14
