# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# Important Users
User.create!(name: 'Andrei',
             email: 'andreisofei2002@gmail.com',
             password: 'delungime8',
             password_confirmation: 'delungime8',
             admin: true)
User.create!(name: 'Adrian',
             email: 'andrei@yahoo.com',
             password: 'delungime8',
             password_confirmation: 'delungime8',
             admin: true)
User.create!(name: 'Luminita',
             email: 'luminitasofei@yahoo.com',
             password: 'delungime8',
             password_confirmation: 'delungime8',
             admin: true)

# Important Teams
Team.create!(name: "Andrei's team",
             leader_id: 1)
Team.create!(name: "Adrian's team",
             leader_id: 2)
Team.create!(name: "Luminita's team",
             leader_id: 3)

# Update team_id attribute for important Users
User.find(1).update_attribute(:team_id, 1)
User.find(2).update_attribute(:team_id, 2)
User.find(3).update_attribute(:team_id, 3)

# Team leaders
15.times do |n|
  name = Faker::Name.name
  email = "example#{n + 1}@yahoo.com"
  password = 'delungime8'
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               admin: false)
end

# Team Creations
15.times do |n|
  name = Faker::Team.name
  Team.create!(name: name,
               leader_id: n + 4)
end

# Update team leaders team_id
15.times do |n|
  User.find(n + 4).update_attribute(:team_id, n + 4)
end

# Other Team Members
75.times do |n|
  name = Faker::Name.name
  email = "example#{n + 16}@yahoo.com"
  password = 'delungime8'
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               admin: false,
               team_id: (n % 18) + 1)
end

# Other Users without teams
10.times do |n|
  name = Faker::Name.name
  email = "example#{n + 91}@yahoo.com"
  password = 'delungime8'
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               admin: false)
end

# Create 3 tournaments for each sport
9.times do |n|
  if (n / 3).zero?
    name = "#{(n%3+1).ordinalize} Golf Tournament"
    sport = 'golf'
  else
    if n / 3 == 1
      name = "#{(n%3+1).ordinalize} Football Tournament"
      sport = 'football'
    else
      name = "#{(n%3+1).ordinalize} Basketball Tournament"
      sport = 'basketball'
    end
  end
  Tournament.create!(name: name,
                     sport: sport,
                     organizer_id: 1,
                     started: false)
end

# Create tournament_paticipations for teams and users
tournaments = Tournament.all
users = User.all
teams = Team.all
# Golf
users[0..15].each do |user|
  user.join_tournament(tournaments[0])
end
users[93..102].each do |user|
  user.join_tournament(tournaments[1])
end
users[0..5].each do |user|
  user.join_tournament(tournaments[2])
end
# Football
teams[0..15].each do |team|
  team.join_tournament(tournaments[3])
end
teams[0..13].each do |team|
  team.join_tournament(tournaments[4])
end
teams[0..6].each do |team|
  team.join_tournament(tournaments[5])
end
# Basketball
teams[0..15].each do |team|
  team.join_tournament(tournaments[6])
end
teams[0..11].each do |team|
  team.join_tournament(tournaments[7])
end
teams[0..5].each do |team|
  team.join_tournament(tournaments[8])
end
