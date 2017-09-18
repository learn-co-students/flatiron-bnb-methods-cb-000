class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings
  

  def neighborhood_openings(start_date, end_date)
    sd = Date.parse(start_date)
  	ed = Date.parse(end_date)

  	listings.select do |listing|
  	  listing.reservations.all? do |res|
  	  	sd >= res.checkout && ed >= res.checkin
  	  end
  	end
  end

  def self.highest_ratio_res_to_listings
    highest = 0
    neighborhood_with_highest_ratio = nil

    self.all.each do |neighborhood|
        res_count = 0
        if neighborhood.listings.count > 0	
        neighborhood.listings.each do |listing|
          res_count += listing.reservations.count
        end
        diff = res_count/neighborhood.listings.count
        if diff > highest
      	  highest = diff
      	  neighborhood_with_highest_ratio = neighborhood
        end
      end
    end
    neighborhood_with_highest_ratio
  end

  def self.most_res
  	highest = 0
  	neighborhood_with_most_res = nil

  	self.all.each do |neighborhood|
  	  res_count = 0
  	  neighborhood.listings.each do |listing|
  	  	res_count = listing.reservations.count
  	    if res_count > highest
  	      highest = res_count
  	  	  neighborhood_with_most_res = neighborhood
  	    end
  	  end
  	end
  	neighborhood_with_most_res
  end


end
