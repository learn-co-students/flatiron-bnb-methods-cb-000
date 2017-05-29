class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, class_name: "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :guest_and_host_not_same_user, :dates_are_available,
    :checkin_before_checkout, :checkin_date_is_not_same_as_checkout

  def self.overlap(start_date, end_date)
    where("? BETWEEN checkin AND checkout", start_date).
    or(where("? BETWEEN checkin AND checkout", end_date))
  end

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price * duration
  end

  private

  def available?
    return unless checkin && checkout

    Reservation.overlap(checkin, checkout).
    where.not(id: self.id).count.zero?
  end

  def guest_and_host_not_same_user
    if listing_id == guest_id
      errors.add(:invalid_guest, 'Guest and host can\'t be the same user')
    end
  end

  def dates_are_available
    if !available?
      errors.add(:invald_dates, 'Your dates are not available.')
    end
  end

  def checkin_before_checkout
    return unless checkin && checkout

    if checkout < checkin
      errors.add(:invald_dates, "Your check-out date needs to be after your check-in.")
    end
  end

  def checkin_date_is_not_same_as_checkout
    return unless checkin && checkout

    if checkin == checkout
      errors.add(:invald_dates, 'checkout and checkin can\'t be the same date.')
    end
  end
end
