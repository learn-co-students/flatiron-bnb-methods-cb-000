require 'pry'
class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, presence:true
  validates :listing_type, presence:true
  validates :title, presence:true
  validates :description, presence:true
  validates :price, presence: true
  validates :neighborhood, presence:true
  before_save :make_host
  after_destroy :destroy_host


  def available?(start_date, end_date)
    #expect to return true if listing is available

    #algorithm:
    # 1. Assume listing is available
    # 2. Iterate through reservations:
    # 3. If a reservation overlaps, not available
    # 4. return status
    available = true
    puts "Checking reservations for #{self}"
    self.reservations.each do |r|
      puts "comparing reservation for #{self}: #{r.id}:#{r.checkin} until #{r.checkout}"
      if [start_date, r.checkin].max < [end_date, r.checkout].min
        puts "Checking this listing is taken for #{start_date} to #{end_date}! #{r} #{r.checkin} #{r.checkout}"
        available = false
        puts "should return false"
        return available
      else
        puts "this booking date does not overlap for  #{start_date} to #{end_date}! #{r} #{r.checkin} #{r.checkout}"
        # binding.pry
      end
    end
    # binding.pry
    puts "finished checking.  Listing #{self} is available = #{available} for #{start_date} to #{end_date}"
    return available
  end

  def average_review_rating
    # return average of the review rating
    self.reviews.average(:rating).to_f
  end

  private
    def make_host
      # binding.pry
      user = User.find(host_id)
      user.host = true
      user.save
    end



    def destroy_host
      # check if host has any listings
      # if no listings, set to false and save
      l = Listing.find_by 'host_id == ?', host_id
      if !l
        user = User.find(host_id)
        user.host = false
        user.save
      end
    end
end
