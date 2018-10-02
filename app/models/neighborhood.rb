class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  extend Helper::ClassMethods
  include Helper::InstanceMethods

  after_initialize :make_method

end
