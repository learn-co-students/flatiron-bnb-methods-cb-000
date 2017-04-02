class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    available_listings = []
    self.listings.each do |listing|
      if listing.reservations.none? {|res| (start_date.to_date <= res.checkout && end_date.to_date >= res.checkin)}
        available_listings << listing
      end
    end
    available_listings
  end

  def self.highest_ratio_res_to_listings
    highest_ratio = 0.0
    city_with_highest_ratio = nil
    self.all.each do |city|
      res_count = 0
      city.listings.each do |listing|
        res_count += listing.reservations.count
      end
      ratio = res_count / city.listings.count
      if ratio > highest_ratio
        highest_ratio = ratio
        city_with_highest_ratio = city
      end
    end
    city_with_highest_ratio
  end

  def self.most_res
    city_with_most_res = nil
    amount_of_res = 0
    self.all.each do |city|
      res_count = 0
      city.listings.each do |listing|
        res_count += listing.reservations.count
      end
      if res_count > amount_of_res
        city_with_most_res = city
        amount_of_res = res_count
      end
    end
    city_with_most_res
  end
end
