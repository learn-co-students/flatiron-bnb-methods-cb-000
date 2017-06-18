class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address, :description, :title, :listing_type, :price, :neighborhood

  before_save :host_user
  before_destroy :de_host_user

  def average_review_rating
    self.reviews.collect(&:rating).reduce(:+) / self.reviews.count.to_f
  end

  private
  def host_user
    self.host.update(host: true) unless self.host.host
  end

  def de_host_user
    if self.host.listings.count <= 1
      self.host.update(:host => false)
    end
  end
end
