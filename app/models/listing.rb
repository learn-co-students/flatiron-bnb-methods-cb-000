class Listing < ActiveRecord::Base
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true

  belongs_to :neighborhood
  belongs_to :host, class_name: 'User'
  has_many :reservations
  has_many :reviews, through: :reservations
  has_many :guests, class_name: 'User', through: :reservations

  #before_save :set_status
  before_create :set_status
  after_destroy :destroyed
  def average_review_rating
    reviews.average(:rating)
  end
  def self.available(start_date, end_date)
    if start_date && end_date
      joins(:reservations).
      where.not(reservations: {checkin: start_date..end_date}) &
      joins(:reservations).
      where.not(reservations: {checkout: start_date..end_date})
    else
      []
    end
  end

  private

  def set_status
    self.host.host = true
    self.host.save
  end

  def destroyed
    if self.host.listings.empty?
      self.host.host = false
      self.host.save
    end
  end
end
