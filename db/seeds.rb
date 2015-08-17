# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user_list = [
    ["Arnar Johannsson", "cltippningen@gmail.com", "admin"],
    ["Thomas Jarbo", "thomas.jarbo@olofstrom.se", "admin"],
    ["Thomas Jarbo", "thomas.jarbo@edu.olofstrom.se", "admin"],
    ["Thomas Jarbo", "thomasjarbo@gmail.com", "admin"],
]

user_list.each do |u, e, t|
    User.create(name: u, email: e, user_type: t)
end

event_type_list = [
    ["Kunskapsutveckling", "#FBA61F"],
    ["Värdegrundsarbete", "#66A782"],
    ["Arbetsmiljöarbete", "#51C7DC"],
    ["Övrigt", "#EE398E"]
]

event_type_list.each do |n, c|
    EventType.create(name: n, color: c)
end
