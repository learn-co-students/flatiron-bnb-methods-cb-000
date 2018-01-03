class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  include Place::InstanceMethods
  extend Place::ClassMethods

  after_initialize :create_methods

end
