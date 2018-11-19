require_relative './concerns/city_neighborhood_helpers.rb'

class City < ActiveRecord::Base
  include CityNeighborhoodHelpers

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(checkin_string, checkout_string)
    openings(checkin_string, checkout_string)
  end
end
