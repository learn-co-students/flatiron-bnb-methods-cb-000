class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true
  after_create :host_id_change
  before_destroy :check_host_validity

  def average_review_rating
    sum = 0.0
    ratings = self.reviews.collect {|r| r.rating}
    ratings.each{|a| sum += a}
    sum/ratings.length
  end

private
 def host_id_change
   self.host.host = !self.host.host
   self.host.save
 end

 def check_host_validity
   if self.host.listings.count == 1
     self.host.host = false
     self.host.save
   end
 end

end
