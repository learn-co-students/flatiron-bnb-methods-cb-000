module ApplicationHelper
  module InstanceMethods
  end

  module ClassMethods

    def highest_ratio_res_to_listings
      ratio = {}
      self.all.each do |location|
        res = 0
        listings = 0
        location.listings.each do |listing|
          listings += 1
          res += listing.reservations.length
        end
        if listings != 0
          ratio[location.name] = res / listings
        end
      end
      self.find_by(name: ratio.max_by{|key, value| value}.first)
    end

    def most_res
      locations_res = {}
      self.all.each do |location|
        res = 0
        location.listings.each do |listing|
          res += listing.reservations.length
        end
        locations_res[location.name] = res
      end
      self.find_by(name: locations_res.max_by{|key, value| value}.first)
    end
  end
end
