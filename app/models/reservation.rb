class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review



  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :host_is_not_guest

  validate :available, :check_out_after_check_in, :guest_and_host_not_the_same

  # validate :available

  # def available
  #   open = false
  #   conflicts = []
  #
  #   listing.reservations.each do |existing_reservation|
  #     if ((self.checkin <= existing_reservation.checkout)  &&  (self.checkout >= existing_reservation.checkin))
  #       conflicts << existing_reservation
  #     end
  #   end
  #
  #   if conflicts.empty?
  #     open = true
  #   end
  #   open
  # end

  def available
   Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
     booked_dates = r.checkin..r.checkout
     if booked_dates === checkin || booked_dates === checkout
       errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
     end
   end
  end

   def guest_and_host_not_the_same
     if guest_id == listing.host_id
       errors.add(:guest_id, "You can't book your own apartment.")
     end
   end

   def check_out_after_check_in
     if checkout && checkin && checkout <= checkin
       errors.add(:guest_id, "Your check-out date needs to be after your check-in.")
     end
   end

  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.listing.price * duration
  end

  def host_is_not_guest
    if guest_id == listing.host_id
     errors.add(:guest_id, "You can't book your own apartment.")
   end


  end


end
