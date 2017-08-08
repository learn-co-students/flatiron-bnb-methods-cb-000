class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings


  def neighborhood_openings( start_date, end_date )
    #This works if there are no overlaps in the existing reservations
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
    Neighborhood.find_by_sql("select n.id, n.name, COUNT(n.id) as num_res from neighborhoods n JOIN cities c on c.id = n.city_id JOIN listings l on n.id = l.neighborhood_id JOIN reservations r on l.id = r.listing_id group by c.id, c.name ORDER BY num_res DESC LIMIT 1").first
  end

end
