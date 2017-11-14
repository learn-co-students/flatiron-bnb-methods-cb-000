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

  # def checkin
  # end
  #
  # def checkout
  # end


end
