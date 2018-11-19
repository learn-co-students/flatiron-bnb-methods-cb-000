class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :presence => true
  validates :description, :presence => true
  validates :reservation, :presence => true
  validate :trip_completed

  def trip_completed
    if self.reservation == nil || self.reservation.status != "accepted" || self.reservation.checkout > Date.today
      errors[:reservation] = "must have actually stayed at listing"
    end
  end

end
