# frozen_string_literal: true

class Team < ApplicationRecord
  belongs_to :leader, class_name: 'User'
  has_many :members, class_name: 'User', dependent: :nullify

  has_many :team_invitations, dependent: :destroy
  has_many :users, through: :team_invitations

  has_many :tournament_participating_teams, dependent: :destroy
  has_many :tournaments, through: :tournament_participating_teams, source: :tournament

  validates :leader_id, presence: true,
                        uniqueness: true
  validates :name, presence: true,
                   uniqueness: true,
                   length: { minimum: 4 }
  def invite_to_team(user)
    users << user
    invitation = TeamInvitation.find_by(user_id: user.id, team_id: id)
    invitation.update_attribute(:created_by, 'user')
  end

  def deny_invitation(user)
    users.delete(user)
  end

  def approve_invitation(user)
    user.accept_invitation(self)
  end

  def join_tournament(tournament)
    tournaments << tournament
  end

  def leave_tournament(tournament)
    tournaments.delete(tournament)
  end
end
