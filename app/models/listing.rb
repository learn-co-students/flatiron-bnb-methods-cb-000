class Listing < ActiveRecord::Base
  validates :address, presence: :true
  validates :listing_type, presence: :true
  validates :title, presence: :true
  validates :description, presence: :true
  validates :price, presence: :true
  validates :neighborhood, presence: :true
  
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  after_create :hostify_user
  before_destroy :unhostify_user


  def hostify_user
    host.host = true
    host.save
  end

  def unhostify_user
    host_listings = Listing.all.select{|listing| listing.host == host}
    if host_listings.length == 1
      host.host = false
    end
    host.save
  end

  def average_review_rating
    total_reviews = 0
    self.reviews.each{|review| total_reviews += review.rating}
    total_reviews / self.reviews.length.to_f
  end

end
