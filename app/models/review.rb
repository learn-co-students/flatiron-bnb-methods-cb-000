class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"


  validates_presence_of :rating, :description, :reservation
  validate :existing_res, :checkout


  def existing_res
    if reservation.try(:status) != 'accepted'
      errors.add(:reservation, "You need an existing reservation to leave a review.")
    end
  end

  def checkout
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "Checkout has to happended to leave a review")
    end
  end


end
