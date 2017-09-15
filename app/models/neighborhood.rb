class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
     available_listings = []
     self.listings.each do |listing|
       if listing.reservations.none? {|res| (start_date.to_date <= res.checkout && end_date.to_date >= res.checkin)}
         available_listings << listing
       end
     end
     available_listings
   end

   def self.highest_ratio_res_to_listings
     highest_ratio = 0
     neighborhood_with_highest_ratio = nil
     self.all.each do |neighborhood|
       res_count = 0
       if neighborhood.listings.count > 0
         neighborhood.listings.each do |listing|
           res_count += listing.reservations.count
         end
         ratio = res_count / neighborhood.listings.count
         if ratio > highest_ratio
           highest_ratio = ratio
           neighborhood_with_highest_ratio = neighborhood
         end
       end
     end
     neighborhood_with_highest_ratio
   end

   def self.most_res
     neighborhood_with_most_res = nil
     highest_amount_res = 0
     self.all.each do |neighborhood|
       res_count = 0
       neighborhood.listings.each do |listing|
         res_count += listing.reservations.count
       end
       if res_count>highest_amount_res
         highest_amount_res = res_count
         neighborhood_with_most_res = neighborhood
       end
     end
     neighborhood_with_most_res
   end


end
