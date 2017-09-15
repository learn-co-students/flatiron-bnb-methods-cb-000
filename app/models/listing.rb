class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  after_save :set_host
  before_destroy :unset_host


  validates :address,
            :listing_type,
            :title,
            :description,
            :price,
            :neighborhood_id,
            :host,
            presence: true

  def average_review_rating
    self.reviews.average(:rating)
  end

  def set_host
    if !host.host?
      host.update(host: true)
    end
  end

  def unset_host
    #we set this to one to account for the fact of the current listing we are trying to destroy still exists
    if host.listings.count <= 1
      host.update(host: false)
    end
  end


end
