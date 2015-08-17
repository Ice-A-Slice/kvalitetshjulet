class User < ActiveRecord::Base
#----->
#Class is reviewed but needs to be fixed later on.
#----->


  before_save :to_lower_case
  has_many :school_users
  has_many :user_workgroups
  has_many :workgroups, through: :user_workgroups
  has_many :schools, through: :school_users
  has_many :events, as: :user_or_school
  has_many :high_lights
  validates :name, :email, :user_type,  presence: true
  validates :name, :email, length: { maximum: 60 }
  validates :email, uniqueness: true
  validates_confirmation_of :email

  after_destroy :ensure_an_admin_remains


#Used to import new users checks if user already exsists through email ( extrem fulfix med parameters i modellen )
def self.import(file)  
  spreadsheet = open_spreadsheet(file)
  if spreadsheet == false
    return [nil, {error: ['Det här filformatet stöds inte.']}]
  end
  header = spreadsheet.row(1)
  no_school_errors = Array.new
  (2..spreadsheet.last_row).each do |i|  
    row = Hash[[header, spreadsheet.row(i)].transpose]  
    user = find_by_email(row['E-mail']) || new
    parameters = ActionController::Parameters.new(row.to_hash)

    if parameters['Förnamn'].present? and parameters['Efternamn'].present? and parameters['E-mail'].present?
      user.name = "#{parameters['Förnamn']} #{parameters['Efternamn']}"
      user.email = parameters['E-mail']

      # Sets user.user_type to 'teacher' if Roll is equal to 'Personal',
      # otherwise sets it to principal
      case parameters['Roll']
        when 'Personal', 'personal'
          user.user_type = 'teacher'
        when 'Rektor', 'rektor'
          user.user_type = 'principal'
        else
          user.user_type = 'teacher'
      end
      user.save!

      if parameters['Skola'].present? and School.exists?(name: parameters['Skola'])

        school_id = School.where(name: parameters['Skola']).first.id
        unless user.schools.exists?(id: school_id)
          active_user = SchoolUser.new
          active_user.user_id = user.id
          active_user.school_id = school_id

          active_user.save!
        end

      else
        unless no_school_errors.map{|a| a[0]}.include? parameters['Skola']
          no_school_errors << [parameters['Skola'],
                              "Skolan #{parameters['Skola']} existerar inte, var vänlig skapa den först och ladda sedan upp filen igen"]
        end
      end
    else
      unless no_school_errors.map{|a| a[0]}.include? 'name'
        no_school_errors << ['name', 'Strukturen i filen är fel. Kolla stavfel i titel-raden.']
      end
    end
  end
  if no_school_errors.count > 0
    no_school_errors.collect!{|e| e[1]}
    return [nil, {:error => no_school_errors}]
  else
    return [true, {}]
  end
end  


def self.open_spreadsheet(file)  
  case File.extname(file.original_filename)  
     when '.csv' then Roo::Csv.new(file.path, nil, :ignore) 
     when '.xls' then Roo::Excel.new(file.path, nil, :ignore) 
     when '.xlsx' then Roo::Excelx.new(file.path, nil, :ignore)  
     else return false
  end  
end  

  #Handles the google auth request. -> Don't touch!
  def self.from_omniauth(auth)
    user = User.where(:email => auth.info.email)
    if user
        user.each do |f|
          f.oauth_token = auth.credentials.token
          f.oauth_expires_at = Time.at(auth.credentials.expires_at)
          f.save!
        end
      else
    end
  end

  # Looks for users that are admins and sends them to ensure_an_admin_remains
  User.where(:user_type == "Admin").scoping do
    after_destroy :ensure_an_admin_remains
  end

  private

  # If there is only one admin left in the system, it cant be deleted
  def ensure_an_admin_remains
    if User.where(:user_type == "Admin").count.zero?
      render :text => "Det måste finnas minst en admin användare"
    end
  end
  def to_lower_case
    self.email = self.email.downcase
  end
end

#--> Review by Niklas 10:44 11/3-14
