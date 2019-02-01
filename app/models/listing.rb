class Listing < ActiveRecord::Base

  before_create :change_user_status
  before_destroy :clear_host_status

  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true

  def average_review_rating
    ratings = []
    self.reservations.each do |r|
      ratings << r.review.rating
    end

    ratings.sum.to_f / ratings.count
  end

  def change_user_status
      self.host.update(host: true)
  end

  def clear_host_status
    if self.host.listings.count <= 1
      host.update(host: false)
    end
  end

end
