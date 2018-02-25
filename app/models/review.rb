class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  has_one :listing, through: :reservation

  validates_presence_of :description, :rating

  validate :reservation_existed

  def reservation_existed
      if self.reservation == nil || self.reservation.checkout >= Time.now || self.reservation.status != "accepted"
          errors.add(:reservation, "Reservation needs to exist in the past.")
      end
  end

  # validate :reservation_is_past, :status_is_accepted
  #
  # def reservation_is_past
  #     if Time.now < self.reservation.checkout
  #         errors.add(:reservation, "You must check out before leaving a rating.")
  #     end
  # end
  #
  # def status_is_accepted
  #     if !self.reservation.status == "accepted"
  #         errors.add(:status, "This is not an accepted reservation.")
  #     end
  # end

end
