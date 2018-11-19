module CityNeighborhoodHelpers
  def self.included base
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  module InstanceMethods
    def openings(checkin_string, checkout_string)
      checkin = Date.parse(checkin_string)
      checkout = Date.parse(checkout_string)
      self.listings.collect do |listing|
        overlapping_reservations = listing.reservations.collect do |reservation|
          #check to see if the reservation overlaps with the supplied dates
          #if the reservation does overlap, add this reservation to the collection of reservations
          reservation.checkin < checkout && reservation.checkout > checkin
        end
        #if there are no overlapping reservations, add this listing to the collection of listings
        !overlapping_reservations.include?(true) ? listing : nil
      end.compact
    end
  end

  module ClassMethods

    def highest_ratio_res_to_listings
      self.all.collect do |obj|
        {
          obj: obj,
          ratio: obj.listings.count != 0 ? obj.reservations.count / obj.listings.count : 0
        }
      end.max { |a, b| a[:ratio] <=> b[:ratio] }[:obj]
    end

    def most_res
      self.all.collect do |obj|
        {
          obj: obj,
          reservation_count: obj.reservations.count
        }
      end.max { |a, b| a[:reservation_count] <=> b[:reservation_count] }[:obj]
    end
  end
end
