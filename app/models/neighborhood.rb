require_relative './concerns/city_and_neighborhood_helpers.rb'

class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  include CityAndNeighborhoodHelpers

  def neighborhood_openings(start_date, end_date)
    openings(start_date, end_date)
  end
end
