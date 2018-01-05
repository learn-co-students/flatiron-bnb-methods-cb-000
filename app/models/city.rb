class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings( start_date, end_date )
    # Client.where("created_at >= :start_date AND created_at <= :end_date",
    # {start_date: params[:start_date], end_date: params[:end_date]})

    #time_range = (Time.now.midnight - 1.day)..Time.now.midnight
    #Client.joins(:orders).where(orders: { created_at: time_range })
    openings = []
    if start_date && end_date
      #openings = Listing.
      #joins( :reservations ).where.not( reservations: {checkin: start_date..end_date} ) &
      #joins( :reservations ).where.not( reservations: {checkout: start_date..end_date} )

      booked_listings = "select distinct(l.id) FROM cities c JOIN neighborhoods n on c.id = n.city_id JOIN listings l on n.id = l.neighborhood_id JOIN reservations r on l.id = r.listing_id WHERE r.checkin >= #{start_date} AND r.checkout <= #{end_date}"


      Listing.find_by_sql("select l.id, l.title FROM cities c JOIN neighborhoods n on c.id = n.city_id JOIN listings l on n.id = l.neighborhood_id WHERE l.id NOT IN (#{booked_listings})")

    else
      puts "Missing a start/end date."
    end

    #openings
    #openings = []
    #listings.each do |listing|
    #  if start_date > listing.checkout || listing.checkin > end_date
    #  end

  end

  def self.highest_ratio_res_to_listings
    highest_ratio = 0
     city_with_highest_ratio = nil
     self.all.each do |city|
       res_count = 0
       city.listings.each do |listing|
         res_count += listing.reservations.count
       end
       ratio = res_count / city.listings.count
       if ratio > highest_ratio
         highest_ratio = ratio
         city_with_highest_ratio = city
       end
     end
     city_with_highest_ratio
  end

  def self.most_res
    City.find_by_sql("select c.id, c.name, COUNT(c.id) as num_res from cities c JOIN neighborhoods n on c.id = n.city_id JOIN listings l on n.id = l.neighborhood_id JOIN reservations r on l.id = r.listing_id group by c.id, c.name ORDER BY num_res DESC LIMIT 1").first
  end

end
