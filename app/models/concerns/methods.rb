
module Methods

  module InstanceMethods

  def openings(start_date, end_date)
    openings = []
      self.listings.each do |listing|
        if listing.reservations.none? { |res|
          (start_date.to_date >= res.checkin && start_date.to_date <= res.checkout) || (end_date.to_date <= res.checkout && end_date.to_date >= res.checkin)}
        openings << listing
      end
    end
      openings
    end
  end

  module ClassMethods
    def highest_ratio_res_to_listings
      self.has_listings.max_by {|location| location.reservations.count / location.listings.count }
    end

    def most_res
      self.has_listings.max_by {|location| location.reservations.count }
    end

    def has_listings
      self.all.select {|location| location.listings.any? }
    end

  end



end
