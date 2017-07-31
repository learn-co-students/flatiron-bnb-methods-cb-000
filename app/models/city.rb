class City < ActiveRecord::Base
  include Shareable::InstanceMethods
  extend Shareable::ClassMethods

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(checkin, checkout) #return ALL listing objects for ENTIRE SPAN that is inputted
    overlap(checkin, checkout)
  end

end
