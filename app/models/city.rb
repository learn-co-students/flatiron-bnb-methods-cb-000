class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  extend Comparison::ClassMethods
  include Comparison::InstanceMethods

end
