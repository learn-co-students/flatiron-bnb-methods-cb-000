module ApplicationHelper
  module ClassMethods

    def highest_ratio_res_to_listings
      self.has_listings.max_by {|location| location.reservations.count / location.listings.count}
    end

    def most_res
      self.has_listings.max_by {|location| location.reservations.count}
    end

    def has_listings
      self.all.select {|location| location.listings.any?}
    end
  end
end
