module Reservable

  module InstanceMethods
    def ratio_reservations_to_listings
      if listings.count > 0
        self.reservations.count.to_f / self.listings.count.to_f
      else
        #we include this because
        #we are getting neighborhood can't compare neighborhood
        #as it returns nil and can't compare for max to work
        0.to_f
      end
    end
  end

  module ClassMethods
    def most_res
      all.max do |a,b|
        a.reservations.count <=> b.reservations.count
      end
    end

    #list the neighborhood with the highest ratio of reservations to listings
    def highest_ratio_res_to_listings
      all.max do |a,b|
        a.ratio_reservations_to_listings <=> b.ratio_reservations_to_listings
      end
    end
  end

end
