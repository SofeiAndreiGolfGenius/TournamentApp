class Team < ApplicationRecord
  belongs_to :leader, class_name: 'User', dependent: :destroy
  has_many :members, class_name: 'User'
  validates :leader_id, presence: true,
                        uniqueness: true
  validates :name, presence: true,
                   uniqueness: true,
                   length: { minimum: 4 }
end
