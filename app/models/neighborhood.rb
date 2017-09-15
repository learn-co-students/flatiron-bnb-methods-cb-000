class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  include Reservable::InstanceMethods
  extend Reservable::ClassMethods

  def neighborhood_openings(start_date, end_date)
       listings.reject do |listing|
         listing.reservations.any? do |reservation|
           reservation.checkin <= Date.parse(end_date) && reservation.checkout >= Date.parse(start_date)
         end
     end
  end

end
