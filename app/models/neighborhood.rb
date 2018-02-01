class Neighborhood < ActiveRecord::Base
  extend ApplicationHelper::ClassMethods

  belongs_to :city
  has_many :listings


  def neighborhood_openings(date_one, date_two)
    self.listings.select do |listing|
      openings = listing.reservations.select do |res|
        r1 = Date.parse(date_one)
        r2 = Date.parse(date_two)
        r1 <= res.checkout && r2 >= res.checkin ? true : false
      end
      openings.empty?
    end
  end
end
