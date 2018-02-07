class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(date_begin, date_end)
    self.listings.find_all do |listing|
      listing.available?(date_begin, date_end)
    end
  end

  def self.highest_ratio_res_to_listings
    hash_of_ratios = {}
    City.all.each do |city|
      hash_of_ratios[city] = city.number_of_reservations.to_f/city.listings.size
    end
    hash_of_ratios.sort_by {|city, ratio| ratio}.reverse[0][0]
  end

  def number_of_reservations
    array_of_reservations = self.listings.map {|listing| listing.number_of_reservations}
    array_of_reservations.sum {|reservation_count| reservation_count}
  end

  def self.most_res
    city_reservations = {}
    City.all.each do |city|
      city_reservations[city] = city.number_of_reservations
    end
    city_reservations.sort_by {|city, reservation_count| reservation_count}.reverse[0][0]
  end
end
