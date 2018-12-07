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
  validates :neighborhood_id, presence: true

  before_create :set_host_status
  before_destroy :clear_host_status

  def set_host_status
    self.host.host = true
    self.host.save
  end

  def clear_host_status
    if self.host.listings.count == 1
      self.host.host = false
      self.host.save
    end
  end

  def average_review_rating
    all_ratings = self.reviews.collect do |review|
      review.rating
    end
     all_ratings.sum.to_f / all_ratings.count.to_f
  end

end
