class Message < ApplicationRecord
  belongs_to :friendship

  default_scope -> { order(created_at: :asc) }
  validates :content, presence: true, length: { maximum: 140 }
  validates :sender_id, presence: true
  validates :receiver_id, presence: true

  def read_message
    update_attribute(:read, true)
  end
end
