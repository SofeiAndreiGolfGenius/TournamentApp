# frozen_string_literal: true

class Tournament < ApplicationRecord
  SPORTS = %w[golf football basketball].freeze

  belongs_to :organizer, class_name: 'User'

  has_many :tournament_participating_teams, dependent: :destroy
  has_many :teams, through: :tournament_participating_teams, source: :team

  has_many :tournament_participating_users, dependent: :destroy
  has_many :users, through: :tournament_participating_users, source: :user

  validates :organizer_id, presence: true
  validates :name, presence: true,
                   uniqueness: true,
                   length: { minimum: 4 }
  validates :sport, presence: true

  def scramble_matches
    puts 'Hello, here we scramble the matches'
  end

  def nr_of_rounds
    nr_participants = sport == 'golf' ? users.size : teams.size
    log2_integer = Math.log2(nr_participants).to_i
    Math.log2(nr_participants) == log2_integer ? log2_integer : log2_integer + 1
  end
end
