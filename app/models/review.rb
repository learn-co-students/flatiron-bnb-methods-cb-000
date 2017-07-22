class Review < ActiveRecord::Base
  #review_associations: belongs to the guest and reservation
  #notice: review does not belong to host
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation
  validate :valid_timing

  private

  #valid_timing: validation method returns an error:
  # if the reservation is nil
  # if the status is not accepted
  # if the current time is before the checkout
  def valid_timing
    errors.add(:review, "Invalid timing for review") unless !reservation.nil? && reservation.status == "accepted" && reservation.checkout < Time.current
  end

end
