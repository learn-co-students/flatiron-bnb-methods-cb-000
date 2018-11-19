require_relative './concerns/city_neighborhood_helpers.rb'

class Neighborhood < ActiveRecord::Base
  include CityNeighborhoodHelpers

  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  def neighborhood_openings(checkin_string, checkout_string)
    openings(checkin_string, checkout_string)
  end
end
