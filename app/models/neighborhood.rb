class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(starts, ends)
    self.city.city_openings(starts, ends)
  end

  def self.highest_ratio_res_to_listings
    ratios = {}
    self.all.each do |n|
      reservations = 0
      n.listings.each do |list|
        reservations += list.reservations.size
      end
      ratios[n] = reservations/n.listings.size if n.listings.size > 0
    end
     ratios.key(ratios.values.max)
  end

  def self.most_res
    most = {}
    self.all.each do |n|
      n.listings.each do |list|
        most[n] ? most[n] += list.reservations.size : most[n] = list.reservations.size
      end
    end
    most.key(most.values.max)
  end

end
