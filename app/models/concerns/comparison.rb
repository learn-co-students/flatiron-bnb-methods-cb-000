module Comparison
  extend ActiveSupport::Concern

  module ClassMethods
    def highest_ratio_res_to_listings
      hash_of_ratios = {}
      self.all.each do |location|
        if location.listings.size != 0
          hash_of_ratios[location] = location.number_of_reservations.to_f/location.listings.size
        end
      end
      hash_of_ratios.sort_by {|location, ratio| ratio}.reverse[0][0]
    end

    def most_res
      location_reservations = {}
      self.all.each do |location|
        location_reservations[location] = location.number_of_reservations
      end
      location_reservations.sort_by {|location, reservation_count| reservation_count}.reverse[0][0]
    end
  end

  module InstanceMethods
    def number_of_reservations
      self.listings.map {|listing| listing.number_of_reservations}.sum {|number_of_reservations| number_of_reservations}
    end

    def openings(date_begin, date_end)
      self.listings.find_all do |listing|
        listing.available?(date_begin, date_end)
      end
    end
  end

end
