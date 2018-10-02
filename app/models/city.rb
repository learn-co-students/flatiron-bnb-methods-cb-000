class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  extend Helper::ClassMethods
  include Helper::InstanceMethods

  after_initialize :make_method
end
