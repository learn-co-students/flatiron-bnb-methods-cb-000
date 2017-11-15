require 'pry'
class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkout, presence:true
  validates :checkin, presence:true

  #guest and host are different
  # reservations don't conflict
  # checkout time after checkin time

  def hostIsNotGuest

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
