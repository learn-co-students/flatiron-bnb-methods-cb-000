class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_many :review

  def self.overlap(start_date, end_date)
    where(checkin: start_date..end_date).
    or(where(checkout: start_date..end_date))
  end
end
