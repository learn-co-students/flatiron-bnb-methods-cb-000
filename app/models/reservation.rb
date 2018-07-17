class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  # validations:

  validates_presence_of :checkin, :checkout

  validate :guest_not_host
  validate :checkin_checkout_not_reserved
  validate :checkin_before_checkout

  # custom attributes:

  def duration
    (checkin .. checkout).to_a.count - 1
  end

  def total_price
    duration * listing.price
  end

  private

  # validations:
    def guest_not_host
      errors.add(:guest, "cannot be the same as the host.") if guest == listing.host
    end

    def checkin_checkout_not_reserved
      if checkin && checkout && (checkin .. checkout).to_a != listing.available(checkin, checkout)
        errors.add(:base, "Sorry, this place isn't available during your requested dates.")
      end
    end

    def checkin_before_checkout
      if checkin && checkout && checkin >= checkout
        errors.add(:checkin, "must be before checkout")
      end
    end

end
