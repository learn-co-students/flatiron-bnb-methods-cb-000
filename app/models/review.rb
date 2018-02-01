class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validate :has_reservation

  private

  def has_reservation
    if !reservation || reservation.status != "accepted" || reservation.checkout > Time.now
      errors.add(:review, "You can't rate this place if you have not stayed as a guest")
    end
  end
end
