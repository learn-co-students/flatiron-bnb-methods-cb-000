module Helper

  module InstanceMethods

    def res_to_list
      if self.listings.count > 0
        self.reservations.count.to_f / self.listings.count.to_f
      else
        0
      end
    end

    def make_method
      define_singleton_method(:"#{self.class.name.downcase}_openings") do |start_date, end_date|

        start_date = Date.parse(start_date)
        end_date = Date.parse(end_date)
        available_listings = self.listings.all

        self.reservations.all.each do |res|
          if !(res.checkout <= start_date || res.checkin >= end_date)
            available_listings.delete(res.listing)
          end
        end
        available_listings
      end
    end

  end

  module ClassMethods

    def highest_ratio_res_to_listings
      self.all.max_by do |element|
        element.res_to_list
      end
    end

    def most_res
      self.all.max_by do |element|
        element.reservations.count
      end
    end

  end

end
