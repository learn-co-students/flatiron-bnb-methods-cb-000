class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def host?
    !!(user_status == "host")
  end

  def guest?
    !!(user_status == "guest")
  end

  def guests
    self.listings.collect {|l| l.guests}.flatten
  end

  def hosts
    Reservation.all.collect {|r| r.listing.host}
  end

  def host_reviews
    self.reservations.collect do |r|
      r.review
    end
  end



end
