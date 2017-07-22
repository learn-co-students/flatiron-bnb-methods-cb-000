class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation
  validate :valid_timing

  private

  def valid_timing
    errors.add(:review, "Invalid timing for review") unless !reservation.nil? && reservation.status == "accepted" && reservation.checkout < Time.current
  end

end
