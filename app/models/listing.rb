class Listing < ActiveRecord::Base
    belongs_to :neighborhood
    belongs_to :host, :class_name => "User"
    has_many :reservations
    has_many :reviews, through: :reservations
    has_many :guests, :through => :reservations, :class_name => "User"

    validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood, :host

  before_create do
      self.host.update(host: true)
  end

  after_destroy do
      if self.host.listings.empty?
          self.host.update(host: false)
      end
  end

  def average_review_rating
      return 0 if self.reviews.count == 0

      total = 0.0
      self.reviews.each do |review|
          total += review.rating
      end

      total / (self.reviews.count)
  end

  def dates_booked
      dates = []
      self.reservations.each do |reservation|
          reservation.dates.each do |date|
              dates << date
          end
      end
      dates
  end

  def available?(checkin, checkout)
      r = Reservation.new(checkin: checkin, checkout: checkout)
      c = r.dates & self.dates_booked
      c.empty? ? true : false
  end

end
