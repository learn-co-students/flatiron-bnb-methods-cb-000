class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :title, :address, :listing_type, :description, :price, :neighborhood_id, presence: true

  after_create :host?
  after_destroy :host?

  def average_review_rating
    self.reviews.average(:rating).to_f
  end

  private

  def host?
    user = User.find(self.host_id)
    Listing.where(host_id: user.id).size > 0 ? user.host = true : user.host = false
    user.save
  end

end
