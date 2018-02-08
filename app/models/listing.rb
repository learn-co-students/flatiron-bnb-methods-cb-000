class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  after_create :check_user_type
  after_destroy :check_user_type

  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true


  def check_user_type
    self.host.check_user_type
  end

  def available?(date_begin, date_end)
    !self.reservations.any? do |reservation|
      reservation.checkin < date_end.to_date && date_begin.to_date <= reservation.checkout
    end
  end

  def number_of_reservations
    self.reservations.size
  end

  def average_review_rating
    sum = 0
    self.reviews.each do |review|
      sum += review.rating
    end
    sum.to_f / self.reviews.size
  end
end
