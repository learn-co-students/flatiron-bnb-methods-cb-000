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

  after_save :set_host
  after_destroy :unset_host

  def average_review_rating
    sum_of_reviews = 0
    no_of_reviews = 0
    self.reviews.each do |review|
      no_of_reviews += 1
      sum_of_reviews += review.rating
    end
    sum_of_reviews / no_of_reviews.to_f
  end

  private

  def set_host
    if !host.host
      host.update(host: true)
    end
  end

  def unset_host
    if host.listings.empty?
      host.update(host: false)
    end
  end
end
