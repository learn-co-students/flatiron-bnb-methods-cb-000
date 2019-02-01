class Neighborhood < ActiveRecord::Base
  include CityAndNeighborhoodHelpers::InstanceMethods
  extend CityAndNeighborhoodHelpers::ClassMethods

  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

end
