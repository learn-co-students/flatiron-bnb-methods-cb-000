class City < ActiveRecord::Base
  include ReservationsToListings::InstanceMethods
  extend ReservationsToListings::ClassMethods
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods





  def city_openings(date1, date2)
    self.openings(date1,date2)
  end

end
