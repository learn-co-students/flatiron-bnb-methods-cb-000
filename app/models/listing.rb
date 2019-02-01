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

  before_create :make_host
  before_destroy :take_host

  def make_host
    self.host.host = true
    self.host.save
  end

  def take_host
    if self.host.listings.size == 1
      self.host.host = false
      self.host.save
    end
  end

  def average_review_rating
    num_review = self.reviews.size.to_f
    total = 0.0
    self.reviews.each do |review|
      total += review.rating.to_i
    end
    num_review != 0.0 ? avg = total / num_review : avg = 0.0
    avg
  end



end
