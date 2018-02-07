class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation_id, presence: true
  validate :checked_out?

  def checked_out?
    if self.reservation
      Date.today - self.reservation.checkout >= 0
    end
  end
end
