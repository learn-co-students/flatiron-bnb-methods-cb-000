class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def host_reviews
      reviews = []
      self.listings.each do |listing|
          reviews << listing.reviews
      end
      reviews[0]
  end

  def guests
      guests = []
      self.listings.each do |listing|
          guests << listing.guests
      end
      guests[0]
  end

  def hosts
      self.trips.collect do |trip|
          trip.listing.host
      end
  end

end
