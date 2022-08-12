class Team < ApplicationRecord
  belongs_to :leader, class_name: 'User'
  has_many :members, class_name: 'User'
  validates :leader_id, presence: true
end
