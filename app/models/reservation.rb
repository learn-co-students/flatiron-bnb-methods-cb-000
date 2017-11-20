require 'pry'
class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkout, presence:true
  validates :checkin, presence:true
  # validates :guest_id, exclusion: { in: (self.child.listing.host_id), message: "cannot stay at your own place" }
  validate :hostIsNotGuest
  validate :listingAvailable

  #guest and host are different
  # reservations don't conflict
  # checkout time after checkin time

  def hostIsNotGuest
    if self.listing.host == self.guest
      errors.add(:guest, "guest cannot be host")
    # puts "validating host is not guest. Host: #{self.listing.host.name} and guest: #{self.guest.name}"
    end
  end

  def listingAvailable
    #validate checkin and checkout are both available
    if self.checkin && self.checkout
      if self.checkin == self.checkout
        errors.add(:checkout, "cannot check in and check out on the same day")
      end

      if self.checkin > self.checkout
        puts "comparing dates. Checkin #{self.checkin} greater than checkout #{self.checkout}"
        errors.add(:checkout, "checkout cannot be before checkin")
      end

      #check if listing is available at checkin and checkout
      self.listing.reservations.each do |r|
        if [checkin, r.checkin].max < [checkout, r.checkout].min
          errors.add(:checkout, "dates already taken")
        end
      end
    end
  end




  def duration
    #given instance of reservation, returns length of stay.  checkout - checkin
    # binding.pry
    (checkout - checkin).to_i
  end

  def total_price
    #assume this takes duration and multiplies by price
    duration * self.listing.price.to_f
  end


end
