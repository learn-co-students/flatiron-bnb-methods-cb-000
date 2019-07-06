class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, through: :listings
  has_many :trips, class_name: "Reservation", :foreign_key => 'guest_id'
  has_many :reviews, :foreign_key => 'guest_id'

  # Guest
  has_many :trip_listings, :through => :trips, :source => :listing
  # basically means that guest has_many trip_listings through trips(reservations), look for an association called listing on the reservation model. user.trip_listings will return all listings of the users reservation.
  has_many :hosts, :through => :trip_listings, :foreign_key => 'guest_id'

  # Host
  has_many :guests, :through => :reservations, :class_name => "User"
  has_many :host_reviews, :through => :listings, :source => :reviews
end
