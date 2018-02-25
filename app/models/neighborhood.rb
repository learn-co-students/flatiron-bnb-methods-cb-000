class Neighborhood < ActiveRecord::Base

  extend Comparison::ClassMethods
  include Comparison::InstanceMethods

  belongs_to :city
  has_many :listings

end
