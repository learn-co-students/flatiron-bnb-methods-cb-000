class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  include ResHelper::InstanceMethods
  extend ResHelper::ClassMethods

  def neighborhood_openings(start, finish)
    openings(start, finish)
  end
end
