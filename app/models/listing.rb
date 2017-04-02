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
  after_create :change_host_status
  after_destroy :change_host_status

  def change_host_status
    if self.host.listings.count > 0
      self.host.update(host: true)
    else
      self.host.update(host: false)
    end
  end

  def average_review_rating
    ratings_sum = 0.0
    self.reviews.each do |review|
      ratings_sum += review.rating
    end
    ratings_sum / self.reviews.count
  end
end
