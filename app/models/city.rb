class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  include ListingAmount

  def city_openings(l1, l2)
    openings(l1,l2)
  end

end
