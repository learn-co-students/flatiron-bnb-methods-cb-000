class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true

  validate :two_users
  validate :checkout_after_checkin
  validate :listing_available?

  def duration
    if checkin != nil && checkout != nil
      self.checkout - self.checkin
    end
  end

  def total_price
    self.listing.price * self.duration
  end

  def two_users
    if self.guest_id == self.listing.host_id
      errors.add(:host_id, "The host can not also be the guest")
    end
  end

  def listing_available?
    if checkin != nil && checkout != nil
      if self.listing.available?(checkin, checkout)
        true
      else
        errors.add(:listing_available, "Listing is already reserved")
      end
    end
  end

  def checkout_after_checkin
    if checkin != nil && checkout != nil
      if checkin == checkout
        errors.add(:checkout_date, "Checkin and Checkout can not be on the same day.")
      elsif self.duration < 0
        errors.add(:checkout_date, "Checkin cannot be after Checkout.")
      else
        true
      end
    end
  end

end
