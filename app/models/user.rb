# frozen_string_literal: true

class User < ApplicationRecord
  has_one :team
  has_many :tournaments, dependent: :destroy

  has_many :team_invitations, dependent: :destroy
  has_many :teams, through: :team_invitations

  has_many :tournament_participating_users, dependent: :destroy
  has_many :tournaments, through: :tournament_participating_users, source: :tournament

  has_many :sent_friend_requests, class_name: 'FriendRequest',
                                  foreign_key: 'sender_id',
                                  dependent: :destroy
  has_many :sent_requests_to, through: :sent_friend_requests, source: :receiver
  has_many :received_friend_requests, class_name: 'FriendRequest',
                                      foreign_key: 'receiver_id',
                                      dependent: :destroy
  has_many :received_requests_from, through: :received_friend_requests, source: :sender

  has_many :active_friendships, class_name: 'Friendship',
                                foreign_key: 'user1_id',
                                dependent: :destroy
  has_many :friends1, through: :active_friendships, source: :user2
  has_many :passive_friendships, class_name: 'Friendship',
                                 foreign_key: 'user2_id',
                                 dependent: :destroy
  has_many :friends2, through: :passive_friendships, source: :user1

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

  def join_team(team_id)
    update_attribute(:team_id, team_id)
    teams.delete_all
  end

  def ask_to_join(team)
    teams << team
    invitation = TeamInvitation.find_by(user_id: id, team_id: team.id)
    invitation.update_attribute(:created_by, 'team')
  end

  def decline_invitation(team)
    teams.delete(team)
  end

  def accept_invitation(team)
    update_attribute(:team_id, team.id)
    teams.delete_all
  end

  def join_tournament(tournament)
    tournaments << tournament
  end

  def leave_tournament(tournament)
    tournaments.delete(tournament)
  end

  def send_friend_request(user)
    sent_requests_to << user
  end

  def retract_friend_request(user)
    sent_requests_to.delete(user)
  end

  def accept_friend_request(user)
    # deletes friend request and creates friendship
    friendship = Friendship.new(user1_id: id, user2_id: user.id)
    friendship.save
    received_requests_from.delete(user)
  end

  def reject_friend_request(user)
    received_requests_from.delete(user)
  end

  def sent_request?(user)
    sent_requests_to.include?(user)
  end

  def friends
    friends1 + friends2
  end

  def friendship(user)
    Friendship.where("(user1_id = #{id} and user2_id = #{user.id}) or (user1_id = #{user.id} and user2_id = #{id})").first
  end

  def friend?(user)
    # if both are true then they are not friends
    !(Friendship.find_by(user1_id: id, user2_id: user.id).nil? &&
      Friendship.find_by(user1_id: user.id, user2_id: id).nil?)
  end
end
