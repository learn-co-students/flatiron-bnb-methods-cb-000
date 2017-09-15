class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  #as guest
  #SELECT "listings".* FROM "listings"
  #INNER JOIN "reservations"
  #ON "listings"."id" = "reservations"."listing_id"
  #WHERE "reservations"."guest_id" = ?  [["guest_id", 1]]
  #we can get guest listings through reservations as trips
  has_many :trip_listings, :through => :trips, :source => :listing

  #foreign_key does nothing here
  #so we get guests reservations/listings, then we pull host_id from listings
  has_many :hosts, :through => :trip_listings

  #before foreign_key
  # SELECT "users".* FROM "users" INNER JOIN "listings" ON "users"."id" = "listings"."host_id" INNER JOIN "reservations" ON "listings"."id" = "reservations"."listing_id" WHERE "reservations"."guest_id" = ?  [["guest_id", 1]]
  #after foreign_key
  # SELECT "users".* FROM "users" INNER JOIN "listings" ON "users"."id" = "listings"."host_id" INNER JOIN "reservations" ON "listings"."id" = "reservations"."listing_id" WHERE "reservations"."guest_id" = ?  [["guest_id", 1]]

  #as host
  # SELECT "users".* FROM "users"
  #INNER JOIN "listings"
  #ON "users"."id" = "listings"."host_id"
  #INNER JOIN "reservations" ON "listings"."id" = "reservations"."listing_id"
  #WHERE "reservations"."guest_id" = ?  [["guest_id", 1]]

  has_many :guests, :through => :reservations, :class_name => "User"


  # SELECT "users".* FROM "users"
  #INNER JOIN "listings"
  #ON "users"."id" = "listings"."host_id"
  #INNER JOIN "reservations"
  #ON "listings"."id" = "reservations"."listing_id"
  #WHERE "reservations"."guest_id" = ?  [["guest_id", 1]]
  #will throw error without source
  has_many :host_reviews, :through => :listings, :source => :reviews
end
