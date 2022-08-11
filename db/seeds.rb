# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.create!(name: 'Andrei',
             email: 'andreisofei2002@gmail.com',
             password: 'delungime8',
             password_confirmation: 'delungime8',
             admin: true)
# Create not activated users
User.create!(name: 'Adrian',
             email: 'andrei@yahoo.com',
             password: 'delungime8',
             password_confirmation: 'delungime8',
             admin: false)
# Create not admin users but activated
User.create!(name: 'Luminita',
             email: 'luminitasofei@yahoo.com',
             password: 'delungime8',
             password_confirmation: 'delungime8',
             admin: false)
