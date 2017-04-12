class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  extend Reservable::ClassMethod
  include Reservable::InstanceMethod

  def neighborhood_openings(start_date, end_date)
    listings.reject{|listing| listing.reservations.any?{|res| res.checkin <= Date.parse(end_date) && res.checkout >= Date.parse(start_date)}}
  end

end
