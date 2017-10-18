class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  include ListingAmount

  def neighborhood_openings(l1,l2)
    openings(l1,l2)
  end





end
