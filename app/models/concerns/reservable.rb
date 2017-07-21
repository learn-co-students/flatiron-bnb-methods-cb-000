module Reservable
  extend ActiveSupport::Concern

  module InstanceMethods
    def openings(start_date, end_date)
      self.listings.collect do |listing|
        listing if listing.reservations.none? do |reservation|
          start_date.to_date <= reservation.checkout && end_date.to_date >= reservation.checkin
        end
      end
    end
  end

  module ClassMethods
    def highest_ratio_res_to_listings
      self.has_listings.max_by { |location| location.reservations.count / location.listings.count }
    end

    def most_res
      self.has_listings.max_by { |location| location.reservations.count }
    end

    def has_listings
      self.all.select { |location| location.listings.any? }
    end
  end
end
