class Neighborhood < ActiveRecord::Base
  extend ApplicationHelper::ClassMethods

  belongs_to :city
  has_many :listings

  def neighborhood_openings(date_one, date_two)
    self.listings.select do |listing|
        listing.reservations.select do |reservation|
        Date.parse(date_one) <= reservation.checkout && Date.parse(date_two) >= reservation.checkin ? true : false
        end.empty?
    end 
end

end
