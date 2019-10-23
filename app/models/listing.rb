class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  after_save :set_host_to_true
  before_destroy :set_host_to_false

  def is_available?(start, finish)
    !reservations.find{|res| [res.checkin, start.to_date].max < [res.checkout, finish.to_date].min}
  end

  def average_review_rating
    ratings_array = reviews.map{|review| review.rating}
    ratings_array.sum / ratings_array.size.to_f
  end

  private

  def set_host_to_true
    host.update(host: true) unless host.is_host?
  end

  def set_host_to_false
    if Listing.all.find_all{|listing| listing.host_id == host.id}.count == 1
      host.update(host: false)
    end
  end
end
