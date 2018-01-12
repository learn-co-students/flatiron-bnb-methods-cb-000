class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  belongs_to :city
  has_one :review


  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :no_res_on_own_listing?, :is_listing_available?, :checkout_greater_than_checkin

  def duration
    (self.checkout-self.checkin).to_i
  end

  def total_price
    (self.listing.price.to_i)*duration
  end


  private

  def no_res_on_own_listing?
    if self.listing.host_id == guest_id
      errors.add(:reservation, "You cannot make a reservation on your own listing")
    end
  end

  def is_listing_available?
    self.listing.reservations.each do |reservation|
       if self.checkin.present? && self.checkout.present? && ((self.checkin <= reservation.checkout && self.checkin >= reservation.checkin) || (self.checkout <= reservation.checkout && self.checkout >= reservation.checkin)) && (self != reservation)
         errors.add(:checkin, "Dates Unavailable!")
       end
     end
  end

  def checkout_greater_than_checkin
    if self.checkin.present? && self.checkout.present? && (self.checkout <= self.checkin)
      errors.add(:checkin, "Check-in date must be after Check-out date")
    end
  end


end
