class City < ActiveRecord::Base
  extend ApplicationHelper::ClassMethods
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(start_date, end_date)
    openings = []
    self.listings.each do |listing|
        if listing.reservations.none? { |r| (start_date.to_date <= r.checkout && start_date.to_date >= r.checkin) || (end_date.to_date <= r.checkout && end_date.to_date >= r.checkin)}
          openings << listing
        end
    end
    openings
  end
end
