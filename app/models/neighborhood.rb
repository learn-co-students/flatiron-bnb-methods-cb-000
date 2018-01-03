class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  include Place::InstanceMethods
  extend Place::ClassMethods

  after_initialize :create_methods
  
end
