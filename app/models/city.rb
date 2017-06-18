class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, through: :neighborhoods
  has_many :reservations, through: :listings

  # Returns all of the available apartments in a city, given the date range
  def city_openings(start_date, end_date)
    listings.collect do |listing|
      reservations_in_range = listing.reservations.collect do |reservation|
        reservation.checkin <= end_date.to_date && reservation.checkout >= start_date.to_date
      end
      listing unless reservations_in_range.include?(true)
    end
  end

  # Returns city with highest ratio of reservations to listings
  def self.highest_ratio_res_to_listings
    cities = []
    self.all.each do |city|
      reservations_ratio_in_listings = city.listings.collect do |listing|
        listing.reservations.count
      end
      cities << reservations_ratio_in_listings.sum.to_f / reservations_ratio_in_listings.count
    end
    city_id = cities.each_with_index.max[1] + 1
    self.find(city_id)
  end

  def self.most_res
    # cities = []
    # self.all.each do |city|
    #   binding.pry
    #   reservations_count_in_listings = city.listings.collect do |listing|
    #     listing.reservations.count
    #   end
    #   cities << reservations_count_in_listings.sum
    # end
    # city_id = cities.each_with_index.max[1] + 1
    # self.find(city_id)

    city_id = self.joins(:reservations).group(:city_id).count.max_by{|k,v| v}.first
    self.find(city_id)
  end
end
