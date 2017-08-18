class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"


  validates_presence_of [:rating, :description, :reservation]
  validate :reservation_is_done

  def reservation_is_done
    if [self.rating, self.description, self.reservation].all?{|attr| !attr.nil?}
      if self.reservation.checkout > Date.today
        self.errors[:base] << "Can't make review without reservation and chekout"
      end
    end
  end

end
