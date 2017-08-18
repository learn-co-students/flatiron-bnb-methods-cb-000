class Reservation < ActiveRecord::Base
  #associations
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  #validations
  validates_presence_of [:checkin, :checkout]
  validate :no_reservation_on_my_own_listings
  validate :listing_is_available
  validate :checkin_is_before_chekout
  validate :checkin_and_checkout_not_same


#  before_create do
#    if !self.guest.nil?
#      self.guest.user_status = "guest"
#    end
#  end

  def no_reservation_on_my_own_listings
    if self.listing.host_id == self.guest_id
      self.errors[:base] << "Can't make reservation on your own listings!"
    end
  end

  def listing_is_available
    if [self.checkin, self.checkout].all? {|attr| !attr.nil?}
      if !(self.listing.reservations.all? {|r| self.checkin > r.checkout || self.checkout < r.checkin} || self.listing.reservations.empty?)
        self.errors[:base] << "Listing is unavailable!"
      end
    end
  end

  def checkin_is_before_chekout
    if [self.checkin, self.checkout].all? {|attr| !attr.nil?}
      if checkin > checkout
        self.errors[:checkin] << "Checkin can't be later than chekout "
      end
    end
  end

  def checkin_and_checkout_not_same
    if [self.checkin, self.checkout].all? {|attr| !attr.nil?}
      if self.checkin == self.checkout
        self.errors[:chekin] << "Checkin and chekout date can't be the same"
      end
    end
  end


  def duration
    if [self.checkin, self.checkout].all? {|attr| !attr.nil?}
      checkout - checkin
    end
  end

  def total_price
    self.duration * self.listing.price
  end

end
