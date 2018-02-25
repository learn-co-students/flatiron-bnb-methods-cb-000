class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :neighborhoods

  def self.most_res
      self.all.max_by do |city|
          city.reservations.count
      end
  end

  def city_openings(checkin, checkout)
      available_listings = []
      self.listings.each do |listing|
          available_listings << listing if listing.available?(checkin, checkout)
      end
      available_listings
  end

  def self.highest_ratio_res_to_listings
      City.all.max_by do |city|
          city.reservations.count / city.listings.count
      end
  end

end
