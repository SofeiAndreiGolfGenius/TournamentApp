class Team < ApplicationRecord
  belongs_to :leader, class_name: 'User'
  has_many :members, class_name: 'User', dependent: :nullify

  has_many :team_invitations, dependent: :destroy
  has_many :users, through: :team_invitations

  validates :leader_id, presence: true,
                        uniqueness: true
  validates :name, presence: true,
                   uniqueness: true,
                   length: { minimum: 4 }
  def invite_to_team(user)
    self.users << user
    invitation = TeamInvitation.find_by(user_id: user.id, team_id: self.id)
    invitation.update_attribute(:created_by, 'user')
  end

  def deny_invitation(user)
    self.users.delete(user)
  end

  def approve_invitation(user)
    user.accept_invitation(self)
  end
end
