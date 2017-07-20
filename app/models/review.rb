class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :reservation, presence: true
  validates :rating, presence: true
  validates :description, presence: true
  validate :reservation_status_accepted

 private

 def reservation_status_accepted

    if self.reservation && (self.reservation.checkout > Time.now || self.reservation.status != "accepted")
      errors.add(:reservation, "Must checkout to leave a review")
    end
  end



end
