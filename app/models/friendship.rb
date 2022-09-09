# frozen_string_literal: true

class Friendship < ApplicationRecord
  belongs_to :user1, class_name: 'User'
  belongs_to :user2, class_name: 'User'
  has_many :messages, dependent: :destroy

  validates :user1_id, presence: true
  validates :user2_id, presence: true
end
