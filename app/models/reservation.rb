class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :valid_checkout_checkin?

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price * duration
  end

  private

    def valid_checkout_checkin?
      if checkout && checkin && checkout <= checkin
        errors.add(:checkout , message: "Checkout must be before checkin")
      end
    end

end
