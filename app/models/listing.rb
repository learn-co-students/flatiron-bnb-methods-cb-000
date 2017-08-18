class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of [:address, :listing_type, :title, :description, :price, :neighborhood]

  before_create  do
    self.host.update(user_status: "host")
  end

  after_destroy do
    if self.host.listings.empty?
      self.host.update(user_status: nil)
    end
  end

  def average_review_rating
    self.reviews.collect{|r| r.rating}.inject {|sum, r| sum + r }.to_f / self.reviews.count.to_f
  end

end
