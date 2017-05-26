class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    listings.available(start_date, end_date)
  end

  def self.highest_ratio_res_to_listings
    highest_reservations_by 'listings'
  end

  def self.most_res
    highest_reservations_by 'cities'
  end

  def self.highest_reservations_by(table_name)
    joins(listings: :reservations)
    .order('COUNT(reservations.id) DESC')
    .group("#{table_name}.id").first
  end
end
