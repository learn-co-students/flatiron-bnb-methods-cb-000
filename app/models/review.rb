class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true
  validate :reservation_validation


  def reservation_validation
    if !reservation || reservation.status != "accepted" || reservation.checkout > Date.today
      errors.add(:reservation, "invalid")
    end
  end

end
