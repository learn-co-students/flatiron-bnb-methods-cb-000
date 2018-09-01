class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    listings.find_all { |l| l.reservations.none? { |r| r.checkin < end_date.to_date && r.checkout > start_date.to_date } }
  end

  def self.most_res
    self.all.max_by {|n| n.listings.all.map {|l| l.reservations.count }.sum }
  end

  def self.highest_ratio_res_to_listings    #Handles case where there are no listings
    self.all.max_by {|n| l_cnt = n.listings.size; n.listings.map {|l| l.reservations.count/l_cnt }}
  end 

end

