class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(start_date, end_date)
  	sd = Date.parse(start_date)
  	ed = Date.parse(end_date)

  	listings.select do |listing|
  	  listing.reservations.all? do |res|
  	  	sd >= res.checkout && ed >= res.checkin
  	  end
  	end
  end




  # I know this is some ugly ass code:
  def self.highest_ratio_res_to_listings
    highest = 0
    city_with_highest_ratio = nil

    self.all.each do |city|
      res_count = 0
      city.listings.each do |listing|
      	res_count += listing.reservations.count
      end
      diff = res_count/city.listings.count
      if diff > highest
      	highest = diff
      	city_with_highest_ratio = city
      end
    end
    city_with_highest_ratio
  end

  def self.most_res
  	highest = 0
  	city_with_most_res = nil

  	self.all.each do |city|
  	  res_count = 0
  	  city.listings.each do |listing|
  	  	res_count = listing.reservations.count
  	    if res_count > highest
  	      highest = res_count
  	  	  city_with_most_res = city
  	    end
  	  end
  	end
  	city_with_most_res
  end

end

