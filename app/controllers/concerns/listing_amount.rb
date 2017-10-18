module ListingAmount
  extend ActiveSupport::Concern

  def self.included(including_class)
    including_class.extend ClassMethods
  end

  def openings(l1, l2)
    c_in = l1.to_date
    c_out = l2.to_date
    available = []

    self.listings.each do |listing|
      vacancy = listing.reservations.none? do |r|
        v1 = r.checkin - c_out
        v2 = c_in - r.checkout
        !(v1 >= 0 || v2 >= 0)
      end
      if vacancy == true
        available << listing
      end
    end
    return available
  end

  module ClassMethods

    def most_res
      reservations = {}
      self.all.each do |area|
        count = 0
        area.listings.each {|l| count += l.reservations.count}
        reservations[area.id] = count
      end
      area = self.find(reservations.max_by {|k,v| v}[0])
    end

    def highest_ratio_res_to_listings
      arr = {}
      self.all.each do |area|
        reservations = 0.0
        listings = area.listings.count
        area.listings.each do |listing|
          reservations += listing.reservations.count
        end
        arr[area] = reservations/listings
      end

      ratio = 0.0
      max_value = []

      arr.each_pair do |k,v|
        if v > ratio
          max_value.replace([k])
          ratio = v
        end
      end
      max_value[0]
    end
  end



end
