class Neighborhood < ActiveRecord::Base
  extend Reservable::ClassMethods
  include Reservable::InstanceMethods

  belongs_to :city
  has_many :listings
end
