class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date_string, end_date_string) #inputs are strings
    openings = []
    start_date = start_date_string.to_date
    end_date = end_date_string.to_date
    self.listings.each do |listing|
      if listing.available?(start_date, end_date)
        openings << listing
      end
    end
    openings
  end

  def self.highest_ratio_res_to_listings
    # binding.pry
    top_place = nil
    top_ratio = 0

    self.all.each do |place|
      if place.listings.count > 0
        total = place.listings.map{|l| l.reservations}.sum.count
        # total = c.listings.map{|l| l.reservations}.sum.count
        if total / place.listings.count > top_ratio
          puts "new winner! #{place.name}"
          top_place = place
          top_ratio = total / place.listings.count
        end
      end
    end
    top_place

  end

  def self.most_res
    top_place = self.first
    top_res = 0
    self.all.each do |place|
      if place.listings.count > 0
        total = place.listings.map{|l| l.reservations}.sum.count
        puts "#{place} has #{total} reservations"
        if total > top_res
          puts "new winner! #{place.name}"
          top_place = place
          top_res = total
        end
      end
    end
    top_place
  end

end
