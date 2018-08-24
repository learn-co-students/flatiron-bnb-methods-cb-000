class Listing < ActiveRecord::Base
  belongs_to :neighborhood, required: true
 belongs_to :host, :class_name => "User"
 has_many :reservations
 has_many :reviews, :through => :reservations
 has_many :guests, :class_name => "User", :through => :reservations

 validates :address, presence: true
 validates :listing_type, presence: true
 validates :title, presence: true
 validates :description, presence: true
 validates :price, presence: true

 after_save :set_host_as_host
 before_destroy :unset_host_as_host

 def unset_host_as_host
 # remove .id
   if Listing.where(host: host).where.not(id: id).empty?
     host.update(host: false)
   end
 end



 def set_host_as_host
  unless host.host?
    host.update(host: true)
  end
end



 def average_review_rating
   total = 0
   self.reviews.each do |review|
     total += review.rating
   end
   total / self.reviews.count.to_f
 end

end
