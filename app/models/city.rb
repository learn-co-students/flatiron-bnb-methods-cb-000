class City < ActiveRecord::Base
  include CityAndNeighborhoodHelpers::InstanceMethods
  extend CityAndNeighborhoodHelpers::ClassMethods

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings
end
