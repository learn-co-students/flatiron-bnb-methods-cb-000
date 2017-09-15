class Reservation < ActiveRecord::Base
  validates_presence_of :checkin, :checkout, :status
  validate :host_and_guest_are_not_the_same

  validate :available, :checkin_before_cehckout

  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review


  def duration
    checkout - checkin
  end

  def total_price
    duration * listing.price
  end

  private
  def host_and_guest_are_not_the_same
    if self.listing.host == self.guest
      errors.add(:guest_id, "you cannot reserve your own listing")
    end
  end

  def available
    self.listing.reservations.each do |reservation|
      if checkin && checkout &&((self.checkin <= reservation.checkout && self.checkin >= reservation.checkin)||(self.checkout <= reservation.checkout && self.checkout >= reservation.checkin))&&(self != reservation)
        errors.add(:checkin, "Already booked!")
      end
    end

    # credit to https://github.com/ParagonChuy/flatiron-bnb-methods-cb-000/blob/solution/app/models/reservation.rb
    # Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
    #   booked_dates = r.check_in..r.check_out
    #   if booked_dates === check_in || booked_dates === check_out
    #     errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
    #   end
    # end
  end

  def checkin_before_cehckout
    if checkin && checkout && self.checkin >= self.checkout
      errors.add(:checkin, "Checkin cant be after checkout")
    end
  end
end
