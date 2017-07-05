class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :guest_not_host, :available, :checkin_before_checkout

  def guest_not_host
    if guest_id == listing.host_id
      errors.add(:guest_id, "host and guest cannot be the same")
    end
  end

  def available
    Reservation.where(listing_id: listing_id).where.not(id: id).each do |r|
      dates = r.checkin..r.checkout
      if dates === checkin || dates === checkout
        errors.add(:guest_id, "This listing isn't available during these dates.")
      end
    end
  end

  def checkin_before_checkout
    if checkin && checkout && checkin >= checkout
      errors.add(:guest_id, "Reservation check-in date must be before check-out date.")
    end
  end

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    duration * listing.price
  end

end
