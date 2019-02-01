def wang (date)
  ray = date.to_s.split("-")
  ring = ray.join
  num = ring.to_i
end
class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  def neighborhood_openings(startdate, stopdate)
    start = wang(startdate)
    stop = wang(stopdate)
    emray = []
    self.listings.each do |listing|
      occupied = listing.reservations.any? do |res|
        c_in = wang(res.checkin.to_s)
        c_out = wang(res.checkout.to_s)
        c_in > start && c_in < stop || c_out > start && c_out < stop || c_in < start && c_out > stop
      end
      if occupied == false
        emray << listing
      end
    end
    emray
  end

  def self.highest_ratio_res_to_listings
    emray = ["",0]
    self.all.each do |hood|
      list = hood.listings.size
      res = hood.reservations.size
      list != 0 ? ratio = res / list : ratio = 0
      if ratio > emray[1]
        emray = [hood, ratio]
      end
    end
    emray[0]
  end

  def self.most_res
    emray = ["",0]
    self.all.each do |hood|
      res = hood.reservations.size
      if res > emray[1]
        emray = [hood, res]
      end
    end
    emray[0]
  end


end
