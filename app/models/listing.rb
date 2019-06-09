class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  before_create :change_user_status
  before_destroy :clear_host_status


  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id


  def average_review_rating
    ratings = []
      self.reservations.each do |res|
      ratings << res.review.rating
   end

   ratings.sum.to_f / ratings.size
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
