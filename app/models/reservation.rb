class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: :true
  validate :not_host_of_listing, :check_out_after_check_in, :available

  def available
    listing.reservations.each do |r|
      booking_days = r.checkin..r.checkout
      if booking_days.include?(checkin) || booking_days.include?(checkout)
        errors.add(:guest, "not available!")
      end
    end
  end

  def duration
   (checkout - checkin).to_i
  end

  def total_price
    listing.price * duration
  end

  def not_host_of_listing
    if guest == listing.host
      errors.add(:guest, "We're reserving our own listings now?!")
    end
  end

  def check_out_after_check_in
    if checkout && checkin && checkout <= checkin
      errors.add(:guest_id, "Your check-out date needs to be after your check-in.")
    end
  end
end
