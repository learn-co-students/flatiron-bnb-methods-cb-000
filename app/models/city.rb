class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    listings.collect do |listing|
      listing.reservations.collect do |reservation|
        reservation.checkin >= start_date && reservation.checkout >= end_date        
      end
    end
  end

end
