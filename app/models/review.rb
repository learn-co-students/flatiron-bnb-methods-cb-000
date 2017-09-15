class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation, presence: true

  validate :stayed, if: :reservation

  def stayed
    if reservation.status != "accepted" || reservation.checkout > Time.now
      errors.add(:reservation, "reservation has to have been accepted and checkout has to have occurred")
    end
  end

end
