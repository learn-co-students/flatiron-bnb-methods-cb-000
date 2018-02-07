class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true

  validate :two_users
  validate :listing_available?
  validate :checkout_after_checkin

  def duration
    if checkin != nil && checkout != nil
      self.checkout - self.checkin
    end
  end

  def total_price
    self.listing.price * self.duration
  end

  def two_users
    self.guest_id != self.listing.host_id
  end

  def listing_available?
    if checkin != nil && checkout != nil
      self.listing.available?(checkin, checkout)
    end
  end

  def checkout_after_checkin
    if checkin != nil && checkout != nil
    self.duration > 0
    end
  end

end
