class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, through: :listings, :foreign_key => 'host_id'
  has_many :guests, through: :listings, through: :reservations, :foreign_key => 'host_id'
  has_many :host_reviews
  has_many :reviews, through: :host_reviews, :foreign_key => 'host_id'

  has_many :trips, class_name: "Reservation", :foreign_key => 'guest_id'
  has_many :reviews, :foreign_key => 'guest_id'
end
