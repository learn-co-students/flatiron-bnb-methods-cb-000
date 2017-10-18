class Reservation < ActiveRecord::Base
  include ListingAmount
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true
  validate :check_in_and_check_out

  def duration
    t = self.checkout - self.checkin
  end

  def total_price
    self.listing.price * duration
  end

  private
  def check_in_and_check_out

    if self.listing.host.id == self.guest_id
      errors.add(:guest_id, "Cannot be same as host")
    end

    if self.checkin == self.checkout
      errors.add(:checkin, "cannot be the same as checkout")
    end

    if self.checkin == nil
      errors.add(:checkin, "cannot be empty")
    elsif self.checkout == nil
      errors.add(:checkout, "cannot be empty")
    elsif self.checkin > self.checkout
      errors.add(:checkin, "cannot be later than checkout")
    else
      vacancy = self.listing.reservations.none? do |r|
        v1 = r.checkin - self.checkout
        v2 = self.checkin - r.checkout
        !(v1 >=0 || v2 >= 0)
      end
      if vacancy != true
        errors.add(:checkin, "cannot overlap with an existing reservation")
      end
    end
  end

end
