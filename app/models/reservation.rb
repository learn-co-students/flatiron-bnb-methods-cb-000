class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validates :duration, numericality: {greater_than: 0, message: "Your check-out date needs to be after your check-in." }
  validate :available, :host_and_guest_different

  def duration
    checkinout_set ? (checkout - checkin).to_i : 0
  end 

  def total_price
    listing.price * duration
  end


  private

    def available
      Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
        if checkinout_set && r.checkin < checkout && r.checkout > checkin
          errors.add(:guest_id, "Sorry, it's unavailable during your requested dates.")
        end
      end
    end

    def checkinout_set
      checkin && checkout
    end

  def host_and_guest_different
    if guest_id == listing.host_id
      errors.add(:guest_id, "You can't book your own place.")
    end
  end


end
