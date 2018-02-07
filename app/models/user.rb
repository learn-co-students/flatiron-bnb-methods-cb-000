class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def check_user_type
    if self.listings != 0
      self.host = true
    else
      self.host = false
    end
  end

  def guests
    guests = []
    self.listings.each do |listing|
      listing.reservations.each do |reservation|
        guests << reservation.guest
      end
    end
    guests
  end

  def hosts
    self.trips.map do |reservation|
      reservation.listing.host
    end
  end

  def host_reviews
    self.listings.map {|listing| listing.reviews.flatten}.flatten
  end
end
