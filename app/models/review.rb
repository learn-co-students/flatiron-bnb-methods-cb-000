class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description

  validate :after_checkout
  validate :reservation_accepted

  private
  def after_checkout
    if  reservation && reservation.checkout > Date.today
      errors.add(:reservation, "You can submit your review after you checkout")
    end
  end
  def reservation_accepted
    if reservation.try(:status) != "accepted"
      errors.add(:reservation, "You can submit your review on accepted reservation")
    end
  end
end
