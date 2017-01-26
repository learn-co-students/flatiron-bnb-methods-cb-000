class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def self.most_res
    self.all.max do |a,b|
      a.reservations.count <=> b.reservations.count
    end
  end

  #list the city with the highest ratio of reservations to listings
  def self.highest_ratio_res_to_listings
    self.all.max do |a,b|
      a.ratio_reservations_to_listings <=> b.ratio_reservations_to_listings
    end
  end

  def ratio_reservations_to_listings
    if listings.count > 0
      self.reservations.count.to_f / self.listings.count.to_f
    end
  end

  def city_openings(start_date,end_date)
    self.listings.select do |listing|
      #need to loop through all reservations
      listing.reservations.all? do |res|
        #is any reservation within the date range
        # (StartDate1 <= EndDate2) and (StartDate2 <= EndDate1)
        res.checkin <= Date.parse(end_date) && res.checkout <= Date.parse(start_date)
      end
    end
  end

end

