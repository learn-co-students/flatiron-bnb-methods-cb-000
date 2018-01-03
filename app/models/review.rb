class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, presence: true
  validates :rating, presence: true
  validates :reservation_id, presence: true
  validate :reservation_passed

  def reservation_passed
    if !(self.reservation && (self.reservation.checkout < Time.now))
      errors.add(:reservation_id, "Invalid reservation.")
    end
  end

end
