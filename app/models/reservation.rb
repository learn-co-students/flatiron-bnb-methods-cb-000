class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :own_listing, :listing_available, :checkin_before_checkout


  def own_listing
    if guest == listing.host
      errors.add(:listing, "you cannot book a listing you are hosting")
    end
  end

  def listing_available
  Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
     booked_dates = r.checkin..r.checkout
     if booked_dates === checkin || booked_dates === checkout
       errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
     end
   end
 end

 def checkin_before_checkout
   if checkout && checkin && checkout <= checkin
    errors.add(:guest_id, "Checkin must be before checkout.")
  end
 end

 def duration
   duration = (checkout-checkin).to_i
 end

 def total_price
   total_price = listing.price * duration
 end


end
