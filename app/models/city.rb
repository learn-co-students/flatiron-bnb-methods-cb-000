class City < ActiveRecord::Base
  extend ApplicationHelper::ClassMethods

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(date_one, date_two)
    self.listings.select do |listing|
      reservations_on_dates = listing.reservations.select do |reservation|
        r_start = Date.parse(date_one)
        r_end = Date.parse(date_two)
        checkin = reservation.checkin
        checkout = reservation.checkout
        r_start <= checkout && r_end >= checkin ? true : false
      end
      reservations_on_dates.empty?
    end
  end
end

