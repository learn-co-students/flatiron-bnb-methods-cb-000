class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating,
            :description,
            :reservation,
            presence: true

  validate :stayed, if: :reservation

  def stayed
    if reservation.status != "accepted" || reservation.checkout > Time.now
      errors.add(:reservation, "can not write a review until stay has been been completed")
    end
  end

end
