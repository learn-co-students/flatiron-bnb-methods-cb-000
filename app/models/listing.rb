class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, :listing_type, :title, :description, 
            :price, :neighborhood, presence: true


  before_create {self.host.update(host: true)}
  after_destroy :check_and_or_update_host_status

  def average_review_rating
    self.reviews.collect(&:rating).reduce(:+) / self.reviews.count.to_f 
  end
  
  private 
  
    def check_and_or_update_host_status
      if self.host.listings.blank?
        self.host.update(host: false)
      end
    end

end
