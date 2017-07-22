class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :guests, through: :reservations

  def hosts
    trips.collect { |trip| Listing.find(Reservation.find(trip.id).listing_id).host }.uniq
  end

  def host_reviews
    reservations.collect { |reservation| reservation.review }
  end

end
