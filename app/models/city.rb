class City < ActiveRecord::Base
  extend Reservable::ClassMethods
  include Reservable::InstanceMethods

  has_many :neighborhoods
  has_many :listings, through: :neighborhoods
end
