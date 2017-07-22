class User < ActiveRecord::Base
  #host_associations: host - listings - reservations && collect reservation.review from host_reviews method
  #guest_associations: guest - trips - reviews && collect trip.hosts from hosts method
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :guests, through: :reservations

  #hosts: method returns for each guest an unique list of hosts from the trips taken
  def hosts
    trips.collect { |trip| Listing.find(Reservation.find(trip.id).listing_id).host }.uniq
  end

  #host_reviews: method returns for each host an array of reviews from reservations
  def host_reviews
    reservations.collect { |reservation| reservation.review }
  end

end
