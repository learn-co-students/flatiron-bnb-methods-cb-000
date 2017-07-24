class Listing < ActiveRecord::Base
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

  before_save :set_host_save
  before_destroy :set_host_destroy

  def average_review_rating
    self.reviews.average(:rating)
  end

  private
    def set_host_save
      if self.host.host == false
        self.host.update(host: true)
      end
    end

    def set_host_destroy
        user_listing = Listing.where(host: self.host).count
        if user_listing == 1
          self.host.update(host: false)
        end
    end

end
