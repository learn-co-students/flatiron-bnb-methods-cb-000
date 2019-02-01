class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  before_create :set_errors

  validates :description, presence: true
  validates :rating, presence: true
  validates :reservation, presence: true
    validate :reservation_accepted
    validate :stay_done?

  def set_errors
    @errors = ActiveModel::Errors.new(self)
  end

  def reservation_accepted
     if reservation.try(:status) != 'accepted'
       errors.add(:reservation, "Reservation must be accepted to leave a review.")
     end
  end

  def stay_done?
    if  self.reservation && self.reservation.checkout > Time.now
      @errors.add(:base, "Must wait until your stay is done to leave a review")
    end
  end

end
