class Listing < ActiveRecord::Base
  #listing_associations: city - neighborhood - listing - host && reservations - guest && review
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  # Listings attribute and association validations
  validates_presence_of :price, :description, :title, :listing_type, :address, :neighborhood

  #Callbacks
  before_create :change_user_to_host
  before_destroy :change_user_to_non_host

  #Instance methods
  def average_review_rating
    self.reviews.average(:rating)
  end

  private

  #changing the User's status as a host based on listing creation or deletion
  def change_user_to_host
    self.host.update(host: true)
  end

  def change_user_to_non_host
    self.host.update(host: false) if self.host.listings.count == 1
  end

end
