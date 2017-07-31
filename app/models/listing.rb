class Listing < ActiveRecord::Base
  include Shareable::InstanceMethods
  extend Shareable::ClassMethods
  
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true

  #callback changes user to host\
  before_create :user_to_host
  after_destroy :host_status

  def average_review_rating
    reviews.average(:rating)
  end

  private

  def user_to_host
    self.host.update(host: true)
  end

  def host_status
    if self.host.listings.empty?
      self.host.update(host: false)
    end
  end

end
