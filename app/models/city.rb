require 'pry'
class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(date_start, date_end)
    starts = Date.parse(date_start)
    no_vacancy = []

    self.listings.each do |list|
      list.reservations.each do |res|
        if (res.checkout - res.checkin) > (starts - res.checkin).abs
          no_vacancy << list
        end
      end
    end
    self.listings - no_vacancy
  end

  def self.highest_ratio_res_to_listings
    ratios = {}
    City.all.each do |city|
      reservations = 0
      city.listings.each do |list|
        reservations += list.reservations.size
      end
      ratios[city] = reservations/city.listings.size
    end
     ratios.key(ratios.values.max)
  end

  def self.most_res
    most = {}
    City.all.each do |city|
      city.listings.each do |list|
        most[city] ? most[city] += list.reservations.size : most[city] = list.reservations.size
      end
    end
    most.key(most.values.max)
  end

end
