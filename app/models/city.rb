class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(check_in, check_out)
    openings = []
    listings.each do |l|
      available = true
      l.reservations.each do |r|
        booking_days = r.checkin..r.checkout
        if booking_days.include?(check_in.to_date) || booking_days.include?(check_out.to_date)
          available = false
        end
      end
      openings << l if available
    end
    openings
  end

  def self.highest_ratio_res_to_listings
    ratios = []
    c_ratios = {}
    City.all.each do |c|
      listings_count = c.listings.length
      reservations_count = c.reservations.length
      if listings_count > 0
        ratio =  reservations_count.to_f / listings_count.to_f
        ratios << ratio
        c_ratios[ratio] = c
      end
    end
    c_ratios[ratios.max]
  end

  def self.most_res
    max_res = 0
    most_res_c = ''
    self.all.each do |c|
      res_count = c.reservations.length
      if res_count > max_res
        max_res = res_count
        most_res_c = c
      end
    end
    most_res_c
  end


end
