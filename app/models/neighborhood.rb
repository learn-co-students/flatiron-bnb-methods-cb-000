class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    start_date = DateTime.parse(start_date).to_date
    end_date = DateTime.parse(end_date).to_date

    openings = []
    conflicts = []

    self.listings.each do |listing|
      listing.reservations.each do |reservation|
        if ((start_date <= reservation.checkout)  &&  (end_date >= reservation.checkin))
         conflicts << reservation
        end
      end

      if conflicts.empty?
        openings << listing
      end

       conflicts.clear
     end
     openings
   end

   def self.highest_ratio_res_to_listings
     best = []
     best_ratio = 0
     Neighborhood.all.each do |neighborhood|
       reservation_count = 0
       listings_count = neighborhood.listings.count

       neighborhood.listings.each do |listing|
         reservation_count += listing.reservations.count
       end

       neighborhood_ratio = reservation_count.to_f / listings_count.to_f

       if neighborhood_ratio > best_ratio
         best_ratio = neighborhood_ratio
         best << neighborhood
       end

     end
     best.last
   end

   def self.most_res
     best = []
     best_reservation_count = 0
     Neighborhood.all.each do |neighborhood|
       neighborhood_reservation_count = 0


       neighborhood.listings.each do |listing|
         neighborhood_reservation_count += listing.reservations.count
       end

       if neighborhood_reservation_count > best_reservation_count
         best_reservation_count = neighborhood_reservation_count
         best << neighborhood
       end

     end
     best.last

   end
end
