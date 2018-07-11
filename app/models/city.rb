class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  #city_openings

  def self.highest_ratio_res_to_listings
    ratio_arr = all.map do |city|
      listings_count = city.listings.count.to_f
      reservations_count = city.listings.map{|l| l.reservations.count}.inject(0, :+).to_f
      listings_count == 0 ? 0 : reservations_count / listings_count
    end

    highest_ratio_id = ratio_arr.index(ratio_arr.max) + 1

    City.find(highest_ratio_id)
  end

  def self.most_res
    res_arr = all.map.with_index{|city| [city.name, city.listings.count]}
    City.find(most_res_id)

    end

    most_res_id = ratio_arr.index(ratio_arr.max) + 1

    City.find(most_res_id)
  end
end
