class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :guest_not_host, :checkout_before_checkin, :available

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price * duration
  end

  def guest_not_host
    if guest == listing.host
      errors.add(:guest_id, "You can't book your own listing.")
    end
  end

  def checkout_before_checkin
    #have to check for nil values
    if checkout && checkin && checkout <= checkin
      errors.add(:guest_id, "Checkout must be after checkin.")
    end
  end

  def available
    #get all reservations for this listing_id execept this
    Reservation.where(listing_id: listing_id).where.not(id: id).each do |r|
      date_range = r.checkin..r.checkout
      #=== does not test for equality, its more like does checkin fit into date_range
      #can also use the .include?() here for range
      if date_range === self.checkin || date_range.include?(self.checkout)
        errors.add(:guest_id, "Sorry, this place isn't available during that time.")
      end
    end
  end

end
