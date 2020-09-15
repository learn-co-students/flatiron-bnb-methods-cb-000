class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  include ResHelper::InstanceMethods
  extend ResHelper::ClassMethods

  def city_openings(start, finish)
    openings(start, finish)
  end
end