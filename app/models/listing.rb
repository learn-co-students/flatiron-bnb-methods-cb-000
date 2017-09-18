class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  after_save :host_status
  after_destroy :host_status

  validates :address,
            :listing_type,
            :title,
            :description,
            :price,
            :neighborhood, presence: true

 

  def average_review_rating
    reviews.average(:rating)
  end

 
    
  def host_status    
      if host.listings.count > 0
        host.update(host: true)
      else
        host.update(host: false)
      end
  end
  
  
   
end




