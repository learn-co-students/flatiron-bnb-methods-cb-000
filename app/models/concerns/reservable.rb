module Reservable
  module InstanceMethods
    def self.included(base)
      define_method("#{base.name.downcase}_openings") do |start_date, end_date|
        listings.available(start_date, end_date)
      end
    end
  end

  module ClassMethods
    def highest_ratio_res_to_listings
      highest_reservations_by 'listings'
    end

    def most_res
      highest_reservations_by self.table_name
    end

    def highest_reservations_by(table_name)
      joins(listings: :reservations)
      .order('COUNT(reservations.id) DESC')
      .group("#{table_name}.id").first
    end
  end
end
