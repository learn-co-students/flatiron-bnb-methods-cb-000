class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  include Methods::InstanceMethods
  extend Methods::ClassMethods

  def neighborhood_openings(start_date, end_date)
   openings(start_date, end_date)
 end

end 
