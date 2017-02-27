class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  include Reservable

  def city_openings(start_date, end_date)
    openings(start_date, end_date)
  end


  # def self.highest_ratio_res_to_listings(limit = 1)
  #   query = <<~SQL
  #     SELECT r.*, AVG(r.rcount) as ave_count
  #     FROM (
  #       SELECT cities.*, count(*) as rcount
  #       FROM cities
  #       INNER JOIN neighborhoods
  #       ON cities.id = neighborhoods.city_id
  #       INNER JOIN listings
  #       ON neighborhoods.id = listings.neighborhood_id
  #       INNER JOIN reservations
  #       ON listings.id = reservations.listing_id
  #       GROUP BY cities.id, listings.id
  #     ) AS r
  #     GROUP BY r.id
  #     ORDER BY ave_count DESC
  #     LIMIT :limit;
  #   SQL
  #   self.find_by_sql([query, {limit: limit}]).first
  # end
  #
  # def self.most_res
  #   query = <<~SQL
  #     SELECT cities.*, count(*) as res_count
  #     FROM cities
  #     INNER JOIN neighborhoods
  #     ON cities.id = neighborhoods.city_id
  #     INNER JOIN listings
  #     ON listings.neighborhood_id = neighborhoods.id
  #     INNER JOIN reservations
  #     ON listings.id = reservations.listing_id
  #     GROUP BY cities.id
  #     ORDER BY res_count DESC
  #     LIMIT 1
  #   SQL
  #   self.find_by_sql([query]).first
  # end
end

