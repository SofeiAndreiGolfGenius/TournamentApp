class User < ApplicationRecord
  has_one :team, dependent: :destroy

  has_many :team_invitations, dependent: :destroy
  has_many :teams, through: :team_invitations

  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]\d]+)*\.[a-z]+\z/i
  validates :name, presence: true
  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: VALID_EMAIL_REGEX }
  has_secure_password
  validates :password, presence: true,
                       length: { minimum: 6 }

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def ask_to_join(team)
    self.teams << team
    invitation = TeamInvitation.find_by(user_id: self.id, team_id: team.id)
    invitation.update_attribute(:created_by, 'team')
  end

  def decline_invitation(team)
    self.teams.delete(team)
  end

  def accept_invitation(team)
    self.update_attribute(:team_id, team.id)
    self.teams.delete_all
  end
end
