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
      puts "Comparing current reservations for listing #{listing.id}"
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

end
