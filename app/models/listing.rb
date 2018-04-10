class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, presence: true
  validates :description, presence: true
  validates :listing_type, presence: true
  validates :price, presence: true
  validates :title, presence: true
  validate :neighborhood_exists

  before_save :set_host
  before_destroy :unset_host

  def average_review_rating
      reviews.average(:rating)
  end

  private
  def self.available(start_date, end_date)
    if start_date && end_date
      joins(:reservations).
        where.not(reservations: {check_in: start_date..end_date}) &
      joins(:reservations).
        where.not(reservations: {check_out: start_date..end_date})
    else
      []
    end
  end
  def unset_host
    if self.host.listings.count <=1
      self.host.update(host: false)
    end
  end
  def set_host
    if !self.host.host?
    self.host.update(host: true)
    end
  end
  def neighborhood_exists
    errors.add(:neighborhood_id, "doesn't exist") unless Neighborhood.exists?(neighborhood_id)
  end
end
