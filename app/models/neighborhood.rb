class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  include Reservable::InstanceMethods
  extend Reservable::ClassMethods

end
