class Tournament < ApplicationRecord
  belongs_to :organizer, class_name: 'User'
  validates :organizer_id, presence: true
  validates :name, presence: true,
                   uniqueness: true,
                   length: { minimum: 4 }
  validates :sport, presence: true
end
