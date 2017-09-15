class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true

  validate :cannot_book_your_own, :reservation_date_valid,
           :reservation_date_specifics

  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.duration * listing.price
  end

  private
    
    def cannot_book_your_own
      if guest_id == listing.host_id
        errors.add(:guest_id, "You cannot make a reservation on your own listing")      
      end
    end

    def reservation_date_valid
      valid_booking = Reservation.where("listing_id = ? AND checkin <= ? AND checkout >= ?",
                      listing_id, checkout, checkin).where.not(id: id).blank?
      
      errors.add(:guest_id, "Reservation is not available for those dates!") unless valid_booking 
    end

    def reservation_date_specifics
      if !checkin.blank? && !checkout.blank? && (checkin > checkout || checkin == checkout) 
        errors.add(:guest_id, "Please check your dates and try again!")
      end
    end
end
