class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true

  validate :guest_not_host
  validate :dates_present
  validate :checkout_after_checkin
  validate :listing_is_available


  def duration
    (checkout - checkin).to_i
  end

  def total_price
    puts "Duration:#{duration}/Price:#{listing.price}"
    duration * listing.price
  end

  def dates_present
    checkin && checkout
  end

  def checkout_after_checkin
    #puts "CheckIn:#{checkin}/CheckOut:#{checkout}/ListingId:#{listing.id}"
    if checkin && checkout && (checkout <= checkin )
      errors.add(:Reservation, "Bad checkin/checkout dates.")
    end

  end

  def guest_not_host
    if guest == listing.host
      errors.add(:Reservation, "You cannot reserve your own listing.")
    end
  end

  def listing_is_available
    if !dates_present
      errors.add(:Reservation, "Missing checkin/checkout dates.")
    else

      #S1<=E2 && S2<=E1 && listing_id is the same
      #puts "Checking CheckIn:#{}"
      Reservation.all.each do |reservation|
        #puts "\tExisting Reservation CheckIns:#{reservation.checkin}/CheckOuts:#{reservation.checkout}/ListingID:#{reservation.listing_id}"
        if checkin<=reservation.checkout && reservation.checkin<=checkout && reservation.listing_id==listing.id
          # There is an overlap
          errors.add( :guest_id, "Reservation dates are not available.")
          #puts "THERE IS AN OVERLAP"
          break
        end
      end # do

    end # if
  end # listing_is_available

end
