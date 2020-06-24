class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  def guests
    guests = []
    self.reservations.each do |res|
      guests << res.guest
    end
    guests
  end

  def host_reviews
    reviews = []
    self.reservations.each do |res|
      reviews << res.review
    end
    reviews
  end

  def hosts
    hosts = []
    self.trips.each do |trip|
      hosts << trip.listing.host
    end
    hosts
  end
end
