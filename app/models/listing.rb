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
  after_create :changes_user_host_status
  after_destroy :changes_user_host_status

  def changes_user_host_status
    if host.listings.count > 0
       host.update(host: true)
     else
       host.update(host: false)
     end
  end

  def average_review_rating
     ratings_total = 0.0
     self.reviews.each do |review|
       ratings_total += review.rating
     end
     ratings_total / reviews.count
   end

end
