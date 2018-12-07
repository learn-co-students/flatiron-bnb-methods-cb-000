class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :reserving_own_listing
  validate :listing_available
  validate :checkin_time_before_checkout
  has_one :host, through: :listing

  def reserving_own_listing
    return unless errors.blank?
    if guest == listing.host
      errors[:guest] = 'cannot be same as host'
    end
  end

  def listing_available
    return unless errors.blank?
    if already_booked?
      errors[:reservation] = 'cannot already be booked'
    end
  end

  def already_booked?
    !!(self.listing.reservations.find do |reservation|
      reservation.checkin < self.checkout && reservation.checkout > self.checkin
    end)
  end

  def checkin_time_before_checkout
    if self.checkin != nil && self.checkout != nil && self.checkin >= self.checkout
      errors[:checkin] = "must be at least one day before checkout"
    end
  end

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    (self.duration * self.listing.price).to_f
  end
end
