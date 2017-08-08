class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  #has_many :guests, :through => :reservations, :class_name => "User"
  has_many :guests, :class_name => "User", :through => :reservations
  has_many :reservations
  has_many :reviews, :through => :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true

  after_create :set_user_host_status
  after_destroy :set_user_host_status

  def set_user_host_status

    if host.listings.count > 0
      host.update( :host => true )
    else
      host.update( :host => false )
    end

    def average_review_rating
      reviews.average( :rating )
      #ratings_total = 0.0
      #listing.reviews.each do |review|
      #  ratings_total += review.rating
      #end
      #ratings_total/listing.reviews.count
    end

  end

end
