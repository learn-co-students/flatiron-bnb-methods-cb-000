class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(checkin, checkout)
    self.listings.select do |l|
      l.reservations.where("checkin <= ? AND checkout >= ?",checkout,checkin).blank?
    end
  end


  def self.highest_ratio_res_to_listings
    self.all.max_by do |n|
      c = n.listings  
      !c.blank? ? c.collect{|k| k.reservations.count}.reduce(:+) / c.count.to_f : 0 
    end
  end

  def self.most_res
    self.all.max_by do |n| 
      !n.listings.blank? ? n.listings.collect{|c| c.reservations.count}.reduce(:+) : 0
    end    
  end

end
