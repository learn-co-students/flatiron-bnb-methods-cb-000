module Reservable
  extend ActiveSupport::Concern

  def openings(start_date, end_date)
    listings.merge(Listing.available(start_date, end_date))
  end


  class_methods do
    def reservation_counts
      self.joins(:reservations).group("#{self.table_name}.id").count
    end

    def listing_counts
      self.joins(:listings).group("#{self.table_name}.id").count
    end

    def highest_ratio_res_to_listings
      res_counts = self.reservation_counts
      listing_counts = self.listing_counts
      valid_listings = listing_counts.keep_if { |k,v| res_counts.key? k }
      ratios = res_counts.merge(valid_listings) do |k, rc, lc|
        rc.to_f / lc.to_f
      end
      mx = ratios.max_by { |k, v| v}
      self.find(mx[0])
    end

    def most_res
      self.find(reservation_counts.max_by { |k, v| v }[0])
    end
  end
end
