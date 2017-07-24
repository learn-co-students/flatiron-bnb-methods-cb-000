module Location

  def self.included base
    base.send :include, InstanceMethods
    base.send :extend, ClassMethods
  end

  module InstanceMethods
    def openings(start_date, end_date)
      all_listings = self.listings
      openings = [] # should include all listings that do not have a reservation
                    # or do not fall in the date range
      all_listings.each do |listing|
        overlaps = false
        listing.reservations.each do |reservation|
          if (start_date.to_date <= reservation.checkout) && (reservation.checkin <= end_date.to_date)
            overlaps = true
          end
        end
        if overlaps == false
          openings << listing
        end
      end
      openings.uniq
    end
  end

  module ClassMethods
    def highest_ratio_res_to_listings
      listings = Listing.all
      highest_res = Listing.first
      listings.each do |listing|
        if highest_res.reservations.count < listing.reservations.count
          highest_res = listing
        end
      end
      if self == City
        highest_res.neighborhood.city
      else
        highest_res.neighborhood
      end
    end

    def most_res
      # City with the most total number of reservations
      cities = self.all
      city_highest_res = self.first
      highest_res = 0
      cities.each do |city|
        res_count = 0
        city.listings.each do |listing|
          res_count += listing.reservations.count
        end
        if highest_res < res_count
          city_highest_res = city
          highest_res = res_count
        end
      end
      city_highest_res
    end
  end
end
