class City < ActiveRecord::Base
  #city_associations: city - neighborhoods - listings - reservations
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  include Reservable::InstanceMethods
  extend Reservable::ClassMethods

  def city_openings(start_date, end_date)
    openings(start_date, end_date)
  end

end
