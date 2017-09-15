class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  extend Reservable::ClassMethod
  include Reservable::InstanceMethod

  def city_openings(start_date, end_date)
    listings.reject{|listing| listing.reservations.any?{|res| res.checkin <= Date.parse(end_date) && res.checkout >= Date.parse(start_date)}}
  end



end
