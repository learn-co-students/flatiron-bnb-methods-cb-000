class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true
  validates :description, presence: true

  before_create :change_user_host_status
  before_destroy :change_host_status_if_no_listings

  def average_review_rating
    review_ratings = self.reviews.collect do |r|
      r.rating
    end
    review_ratings.sum / review_ratings.size.to_f
  end

  def is_available?(date)
    self.reservations.each do |res|
      if date >= res.checkin && date <= res.checkout
        return false
      end
    end
    true
  end

  private

  def change_user_host_status
    self.host.host = true
    self.host.save
  end

  def change_host_status_if_no_listings
      if self.host.listings.count == 1
        self.host.host = false
        self.host.save
      end
  end


end
