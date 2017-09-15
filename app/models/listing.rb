class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :description, :price, :title, :listing_type, :address, :neighborhood, presence: true

  before_save :is_host
  after_destroy :not_host

  def average_review_rating
         self.reviews.average(:rating)
  end

  private

  def is_host
    host.update(host: true)
  end

  def not_host
    if !host.listings.any?
      host.update(host: false)
    end
  end

end
