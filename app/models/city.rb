class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(b_date, e_date)
    self.listings.select do |l|
      l.reservations.all? {|r| b_date.to_date > r.checkout || e_date.to_date < r.checkin} || l.reservations.empty?
    end
  end

  def self.highest_ratio_res_to_listings
    self.all.sort_by{|city| city.reservations_listings_ratio}.last
  end

  def reservations_listings_ratio
    if !self.listings.empty?
      ratio = (self.reservations_count.to_f / self.listings.count.to_f)
    else
      return 0
    end
  end

  def self.most_res
    self.all.sort_by{|city| city.reservations_count }.last
  end

  def reservations_count
    res_count = 0
    self.listings.each {|l| res_count += l.reservations.count}
    res_count
  end

end
