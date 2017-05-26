class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_many :review

  def self.not_overlap(start_date, end_date)
    date_range = start_date..end_date
    
    where.not(checkin: date_range, checkout: date_range).
    or(where(listing_id: nil))
  end
end
