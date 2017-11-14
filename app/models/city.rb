require 'pry'
class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    #given date parameters, query for listings that have these dates available
    binding.pry
  end

end
