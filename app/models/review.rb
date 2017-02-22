class Review < ActiveRecord::Base
  belongs_to :guest, :class_name => "User"
  validates :rating, :description, presence: true

  belongs_to :reservation
  validates :reservation, presence: true
  validates_associated :reservation

  validate :guest_checked_out

  private

    def guest_checked_out
      if reservation && reservation.checkout > Date.today
        errors.add(:reservation, "You have to check out before you can leave a review!")
      end
    end


end
