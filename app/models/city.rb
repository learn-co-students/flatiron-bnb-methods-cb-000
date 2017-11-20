require 'pry'
class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date_string, end_date_string) #inputs are strings
    #given date parameters, query for listings that have these dates available
    openings = []
    start_date = start_date_string.to_date
    end_date = end_date_string.to_date
    self.listings.each do |listing|
      
      if listing.available?(start_date, end_date)
        # puts "City model says: listing is available! #{listing} for #{self}"
        openings << listing
        # puts "should add to array.  All openings: #{openings}"
      else
        # puts "City model says: listing not available! #{listing} for #{self}"
        # puts "Current status of openings: #{openings}"
      end
      # puts "Current status of openings: Length is #{openings.length}. All openings: #{openings}"

    end
    puts openings.length
    openings
    # binding.pry
  end

  def self.highest_ratio_res_to_listings
    # binding.pry
    top_city = City.first
    top_ratio = 0

    City.all.each do |c|
      total = c.listings.map{|l| l.reservations}.sum.count
      if total / c.listings.count > top_ratio

        top_city = c
        top_ratio = total / c.listings.count
      end

    end
    top_city
  end


    def self.most_res
      # assume first city
      top_city = City.first
      top_res = 0
      City.all.each do |c|
        # try this: total = c.listings.map{|l| l.reservations}.count

        total = c.listings.map{|l| l.reservations}.sum.count

        if total > top_res

          top_city = c
          top_res = total
        end
      end
      top_city
    end



end
