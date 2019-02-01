def intize (date)
  ray = date.to_s.split("-")
  ring = ray.join
  num = ring.to_i
end

class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings


  def city_openings(startdate, stopdate)
    start = intize(startdate)
    stop = intize(stopdate)
    emray = []
    self.listings.each do |listing|
      occupied = listing.reservations.any? do |res|
        c_in = intize(res.checkin.to_s)
        c_out = intize(res.checkout.to_s)
        #puts res.checkin
        #puts c_in > start && c_in < stop || c_out > start && c_out < stop || c_in < start && c_out > stop
        c_in > start && c_in < stop || c_out > start && c_out < stop || c_in < start && c_out > stop
      end
      #puts "#{listing.title} has occupied = #{occupied}"
      if occupied == false
        emray << listing
      end
    end
    emray
  end

  def self.highest_ratio_res_to_listings
    emray = ["",0]
    self.all.each do |city|
      list = city.listings.size
      res = city.reservations.size
      ratio = res / list
      if ratio > emray[1]
        emray = [city, ratio]
      end
    end
    emray[0]
  end

  def self.most_res
    emray = ["",0]
    self.all.each do |city|
      res = city.reservations.size
      if res > emray[1]
        emray = [city, res]
      end
    end
    emray[0]
  end



end
