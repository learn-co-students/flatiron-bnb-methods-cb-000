class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :price, :description, :neighborhood,
    presence: true

  after_create :set_user_as_host
  after_destroy :detract_host_status

  def self.available(start_date, end_date)
    left_outer_joins(:reservations).
    merge(Reservation.not_overlap(start_date, end_date))
  end

  def average_review_rating
    reviews.average(:rating)
  end

  private

  def set_user_as_host
    host.update(host: true)
  end

  def detract_host_status
    if host.listings.count.zero?
      host.update(host: false)
    end
  end
end
