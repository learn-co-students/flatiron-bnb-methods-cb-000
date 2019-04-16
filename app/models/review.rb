class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: :true
  validates :description, presence: :true
  validate :has_stayed?

  def has_stayed?
    if rating && description
      if !(self.reservation && self.reservation.status == 'accepted' && self.reservation.checkout < Date.current)
        errors.add(:rating, "You haven't stayed there!")
      end
    end
  end
end
