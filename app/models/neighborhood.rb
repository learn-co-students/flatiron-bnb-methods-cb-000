class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  include Reservable::InstanceMethods
  extend Reservable::ClassMethods



  def neighborhood_openings(start_date,end_date)
    ed = Date.parse(end_date)
    sd = Date.parse(start_date)

    self.listings.select do |listing|
      #need to loop through all reservations
      listing.reservations.all? do |res|
        #is any reservation within the date range
        # (StartDate1 <= EndDate2) and (StartDate2 <= EndDate1)
        res.checkin <= ed && res.checkout <= sd
      end
    end
  end

end
