class Neighborhood < ActiveRecord::Base
  include ReservationsToListings::InstanceMethods
  extend ReservationsToListings::ClassMethods
  belongs_to :city
  has_many :listings


  def neighborhood_openings(date1,date2)
      self.openings(date1,date2)
  end
end
