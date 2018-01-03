module Place

  module InstanceMethods

    def create_methods
      define_singleton_method(:"#{self.class.name.downcase}_openings") do |start_date, end_date|
        self.listings.select do |listing|
          overlap = listing.reservations.any? do |reservation|
            (reservation.checkin <= end_date.to_date) && (reservation.checkout >= start_date.to_date)
          end
          !overlap
        end
      end
    end

  end

  module ClassMethods

    def highest_ratio_res_to_listings
      self.all.max_by do |place|
        num_res = place.listings.to_ary.sum do |listing|
          listing.reservations.count
        end
        result = num_res.to_f / place.listings.count.to_f
        result.nan? ? 0 : result
      end
    end

    def most_res
      self.all.max_by do |place|
        place.listings.to_ary.sum do |listing|
          listing.reservations.count
        end
      end
    end

  end

end
