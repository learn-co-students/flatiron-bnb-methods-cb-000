class Neighborhood < ActiveRecord::Base
  belongs_to :city
    has_many :listings
    has_many :reservations, :through => :listings

    # Returns all of the available apartments in a neighborhood, given the date range
    def neighborhood_openings(start_date, end_date)
      booked_listings = "select distinct(l.id) FROM cities c JOIN neighborhoods n on c.id = n.city_id JOIN listings l on n.id = l.neighborhood_id JOIN reservations r on l.id = r.listing_id WHERE r.checkin >= #{start_date} AND r.checkout <= #{end_date}"
      Listing.find_by_sql("select l.id, l.title FROM cities c JOIN neighborhoods n on c.id = n.city_id JOIN listings l on n.id = l.neighborhood_id WHERE l.id NOT IN (#{booked_listings})")

    end

    # Returns nabe with highest ratio of reservations to listings
    def self.highest_ratio_res_to_listings
      query = "select aggregate.id, aggregate.name, aggregate.listing_num, count(r.id) as res_num, count(cast(r.id as decimal)) / cast(listing_num as decimal) as ratio from (select c.id, c.name, count(l.id) as listing_num from cities c
              JOIN neighborhoods n on c.id = n.city_id
              JOIN listings l on n.id = l.neighborhood_id
              group by c.id, c.name) as aggregate
              JOIN neighborhoods n on aggregate.id = n.city_id
              JOIN listings l on n.id = l.neighborhood_id
              JOIN reservations r on l.id = r.listing_id
              group by aggregate.id, aggregate.name, aggregate.listing_num
              ORDER BY ratio DESC LIMIT 1"
      Neighborhood.find_by_sql(query).first
    end

    # Returns nabe with most reservations
    def self.most_res
      query = "SELECT n.id, n.name, COUNT(n.name) as res_count from neighborhoods n JOIN listings l on n.id = l.neighborhood_id JOIN reservations r on l.id = r.listing_id GROUP BY n.id, n.name ORDER BY res_count DESC LIMIT 1"
      Neighborhood.find_by_sql(query).first
    end
end
