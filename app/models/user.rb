class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'


  def guests
      self.listings.collect do |listing|
        listing.guests
      end.first
  end
def hosts
    self.trips.collect do |reservation|

      reservation.listing.host
    end
end

def host_reviews
    host_reviews = []
   self.guests.each do |guest|
    host_reviews = guest.reviews.collect {|review| review}
   end

   host_reviews
end


end
