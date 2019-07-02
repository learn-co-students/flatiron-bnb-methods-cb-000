class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, through: :listings, :foreign_key => 'host_id'
  has_many :guests, through: :listings, through: :reservations, :foreign_key => 'host_id'
  has_many :host_reviews
  has_many :reviews, through: :guest, :foreign_key => 'host_id' 

  has_many :trips, class_name: "Reservation", :foreign_key => 'guest_id'
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :hosts, class_name: "User", :foreign_key => 'guest_id'
  belongs_to :host, class_name: "User"
  # has_many :hosts, through: :reservations, :foreign_key => 'guest_id'
  # has_many :reviews, through: :listings, through: :reservations, through: :guests, :foreign_key => 'host_id'
end
