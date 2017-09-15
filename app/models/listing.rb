class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true

  before_save :is_host
  after_destroy :not_host

  def average_review_rating
    rating_array = reservations.collect do |res|
      res.review.rating
    end
    rating_array.sum.to_f/rating_array.size.to_f
  end

  private

  def is_host
    host.update(host: true)
  end

  def not_host
    if !host.listings.any?
      host.update(host: false)
    end
  end


end
