class Reservation < ActiveRecord::Base
  include ActiveModel::Validations
  include ReservationsToListings::InstanceMethods

  belongs_to :listing
  belongs_to :guest, class_name: 'User'
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :dates
  validate :different_listing
  validate :listing_available


  def duration
    array = []
    (self.checkin..self.checkout).each {|date| array << date}
    (array.size)-1
  end

  def total_price
    self.duration * self.listing.price
  end

  private

  def different_listing
    if listing.host_id == guest_id
      errors.add(:reservation, 'Cannot reserve your own listing.')
    end
  end


  def listing_available
    reservations = []
    dates = []
    Reservation.all.each do |res|
      if res.id != self.id
        reservations << res
      end
    end

    reservations.each do |reservation|

      dates = reservation.checkin..reservation.checkout
      if dates === self.checkin || dates === self.checkout
        errors.add(:reservation, "This listing isn't available for the selected dates." )
      end
    end

  end




  def dates
    if self.checkin && self.checkout && (self.checkin == self.checkout)
      errors.add(:reservation, "Checkin and checkout must be different.")
    elsif self.checkin && self.checkout && (self.checkin > self.checkout)
      errors.add(:reservation, "Checkin must be before checkout.")
    end
  end


end
