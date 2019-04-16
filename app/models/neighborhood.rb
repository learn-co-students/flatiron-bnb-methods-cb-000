class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(check_in, check_out)
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
    n_ratios = {}
    Neighborhood.all.each do |n|
      listings_count = n.listings.length
      reservations_count = n.reservations.length
      if listings_count > 0
        ratio =  reservations_count / listings_count
        ratios << ratio
        n_ratios[ratio] = n
      end
    end
    n_ratios[ratios.max]
  end

  def self.most_res
    max_res = 0
    most_res_n = ''
    self.all.each do |n|
      res_count = n.reservations.length
      if res_count > max_res
        max_res = res_count
        most_res_n = n
      end
    end
    most_res_n
  end

end
