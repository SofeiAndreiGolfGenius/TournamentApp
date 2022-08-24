# frozen_string_literal: true

class Tournament < ApplicationRecord
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
end
