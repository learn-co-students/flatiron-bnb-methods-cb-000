module Reservable
  module InstanceMethod
    def total_reservations
      array = listings.collect do |listing|
        listing.reservations.size
      end
      array.sum
    end
  end

  module ClassMethod
    def highest_ratio_res_to_listings
      has_listing = self.all.find_all{|o| !o.listings.empty?}
      has_listing.max{|a,b| a.total_reservations/a.listings.size <=> b.total_reservations/b.listings.size}
    end

    def most_res
      self.all.max{|a,b| a.total_reservations <=> b.total_reservations}
    end
  end
end
