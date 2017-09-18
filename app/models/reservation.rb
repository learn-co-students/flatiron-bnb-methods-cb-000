class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"

  has_one :review
  

  validates :checkin,
            :checkout, 
            presence: true

  validate :valid_user, :checkout_before_checkin, :available

  def valid_user
  	if guest_id == listing.host_id
  	  errors.add(:guest, "You can not book your own room!")
  	end
  end

  def duration
    (checkout-checkin).to_i
  end

  def total_price
    duration * listing.price
  end
   

  def available
    Reservation.where(listing_id: listing_id).where.not(id: id).each do |res|
      dates = res.checkin..res.checkout
      if dates === self.checkin || dates.include?(self.checkout)
        errors.add(:guest_id, "Sorry, not available for those days.")
      end
    end
  end

  def checkout_before_checkin
    if checkout && checkin && checkout <= checkin
      errors.add(:guest_id, "Sorry, checkout can not be before checkin.")
    end
  end
  
end
