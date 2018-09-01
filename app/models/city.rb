class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, through: :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(start_date, end_date)
    neighborhoods.flat_map { |n| n.neighborhood_openings(start_date, end_date) }
  end

  def self.most_res
    self.all.max_by {|c| c.reservations.count } 
  end

  def self.highest_ratio_res_to_listings    #Handles case where there are no listings
    self.all.max_by {|c| c.reservations.count/c.listings.count }
  end 

end

