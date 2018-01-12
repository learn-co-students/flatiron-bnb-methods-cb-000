class Listing < ActiveRecord::Base
  before_create :change_user_status
  after_destroy :host_status_removed
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


  def average_review_rating
    ratings = []
    self.reservations.each do |reservation|
      ratings << reservation.review.rating
    end
    ratings.sum.to_f / ratings.size
  end




  private

  def change_user_status
    self.host.host = true
    self.host.save
  end

  def host_status_removed
  if Listing.all.none? {|listing| listing.host == self.host}
    self.host.host = false
  else
    self.host.host = true
  end
  self.host.save
  end



end
