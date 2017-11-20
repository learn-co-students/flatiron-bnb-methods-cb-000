class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence:true
  validates :description, presence:true
  validates :reservation, presence:true
  validate :resNotPassed
  #is invalid without an associated reservation, has been accepted, and checkout has happened (FAILED - 1)


  def resNotPassed
    if self.reservation
      if self.reservation.checkout.future?
        errors.add(:review, "cannot post a review before reservation has completed")
      end
    end


    end





end
