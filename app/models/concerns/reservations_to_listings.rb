module ReservationsToListings
  extend ActiveSupport::Concern
  module ClassMethods
    def highest_ratio_res_to_listings
      max = 0.00
      max_for_locale = ''

      all.each do |locale|
        listing_size = locale.listings.size
        reservation_size = 0.00
        locale.listings.each do |listing|
          reservation_size += listing.reservations.size
        end
        if reservation_size / listing_size > max
          max = reservation_size / listing_size
          max_for_locale = locale
          end
      end
      max_for_locale
     end

    def most_res
      max_locale = ''
      max = 0
      all.each do |locale|
        reservation_size = 0
        locale.listings.each do |listing|
          reservation_size = listing.reservations.size

          if reservation_size > max
            max = reservation_size
            max_locale = locale
          end
        end
      end
      max_locale
    end
  end

module InstanceMethods
  def openings(date1, date2)
        date1.is_a?(DateTime) ? date1 = date1 : date1 = DateTime.parse(date1)
        date2.is_a?(DateTime) ? date2 = date2 : date2 = DateTime.parse(date2)

    open_listings = []
    available_listings = []
    (date1..date2).each do |date|
      open_listings << date #.strftime("%Y-%m-%d")
    end
      self.listings.each do |listing|
      checkouts = []
      checkins = []
      check_times = []
      listing.reservations.each do |reservation|
        (reservation.checkin..reservation.checkout).each do |date|
          check_times << date
        end
      end
        if !check_times.include?(date1) && !check_times.include?(date2)
          available_listings << listing
        end
     end
     available_listings
   end
 end

end
