class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations


  # validations:
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood

  # lifecycle callbacks:
  before_validation :set_host_to_host
  before_destroy :unset_host_to_host

  # custom attributes:

  def average_review_rating
    reviews.average(:rating)
  end

  def available(start_date, end_date) # ('06-01-2014', '10-01-2014')
    date_range = ( start_date .. end_date ).to_a
    dates_reserved = find_reserved_dates()
    date_range - dates_reserved
  end


  private

  # for lifecycle callbacks:

  def set_host_to_host
    host.update(host: true) if host
  end

  def unset_host_to_host
    host.update(host: false) if host && host.listings.count == 1
  end

  # for custom attributes

    ## for custom attribute #available
    def find_reserved_dates
      reserved = []
      self.reservations.each{|r| reserved.concat( (r.checkin .. r.checkout).to_a )}
      reserved
    end
end
