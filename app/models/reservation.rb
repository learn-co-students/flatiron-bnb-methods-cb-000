class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  # has_one :host, through: :listing

  validates_presence_of :checkin, :checkout
  validate :host_isnt_guest
  validate :checkin_is_before_checkout
  validate :listing_available

  after_validation do
      self.status = "accepted"
  end

  def host_isnt_guest
      if self.listing.host_id == self.guest_id
          errors.add(:reservation, "Host can't book their own listing.")
      end
  end

  def checkin_is_before_checkout
      if self.checkin && self.checkout && self.checkin >= self.checkout
          errors.add(:reservation, "Checkin needs to be earlier than checkout.")
      end
  end

  def listing_available
      if self.listing.dates_booked.include?(self.checkin)
          errors.add(:reservation, "That date is already booked.")
      elsif self.listing.dates_booked.include?(self.checkout)
          errors.add(:reservation, "That date is already booked.")
      end
  end

  def duration
      checkout - checkin
  end

  def total_price
      self.listing.price * duration
  end

  def dates
      dates = []
      date = self.checkin
      while date <= self.checkout do
          dates << date
          date += 1
      end
      dates
  end
end
