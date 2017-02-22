class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(checkin, checkout)
    self.listings.select do |l|
      l.reservations.where("checkin <= ? AND checkout >= ?",checkout,checkin).blank?
    end
  end

  def self.highest_ratio_res_to_listings
    self.all.max_by do |city|
      c = city.listings  
      c.collect{|k| k.reservations.count}.reduce(:+) / c.count.to_f
    end
  end

  def self.most_res
    self.all.max_by do |city| 
      city.listings.collect{|c| c.reservations.count}.reduce(:+)
    end    
  end
end
