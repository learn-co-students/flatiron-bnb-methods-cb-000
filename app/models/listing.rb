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


  before_create :set_user_as_host
  before_destroy :set_user_as_user


  def set_user_as_host
    self.host.host = true
  end

  def set_user_as_user
    self.host.host = false
  end

  def average_review_rating
    ratings = []
    self.reviews.each do |review|
      ratings << review.rating
    end
    ratings.sum.fdiv(ratings.size)
  end

end
