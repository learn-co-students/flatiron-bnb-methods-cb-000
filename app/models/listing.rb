class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  def available?(start_date, end_date)
    self.class.available(start_date, end_date).include?(self)
  end

  private
  def self.available(start_date, end_date)
    if start_date && end_date
      joins(:reservations).
        where.not(reservations: {
          checkin: start_date..end_date,
          checkout: start_date..end_date
      }).
      distinct
    else
      []
    end
  end
end
