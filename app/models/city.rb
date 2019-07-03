class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def self.most_res
    hash = {}
    #binding.pry

    City.where(name: 'hash.max_by { |k,v| k }[0]')
  end

end
