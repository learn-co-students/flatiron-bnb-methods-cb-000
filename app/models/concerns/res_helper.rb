module ResHelper
  module InstanceMethods
    def openings(start, finish)
      openings = []
      self.listings.each do |listing|
        openings << listing unless listing.reservations.find {|res| (([res.checkin, start.to_date].max) < ([res.checkout, finish.to_date].min))}
      end
      openings
    end
  end

  module ClassMethods
    def highest_ratio_res_to_listings
      locations = {}
      all.each do |location|
        if location.listings.count > 0
          locations[location] = location.reservations.count/location.listings.count
        end
      end
      locations.max_by{|k, v| v}[0]
    end
  
    def most_res
      locations = {}
      self.all.each do |location|
        locations[location] = location.reservations.count
      end
      locations.max_by{|k, v| v}[0]
    end
  end
end