class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings


  def neighborhood_openings start_date, end_date
    listings.collect do |listing|
      reservations_in_range = listing.reservations.collect do |reservation|
        reservation.checkin <= end_date.to_date && reservation.checkout >= start_date.to_date
      end
      listing unless reservations_in_range.include?(true)
    end
  end

  # The following methods are BAD! I'd love to get them refactored out!
  # Returns nabe with highest ratio of reservations to listings
  def self.highest_ratio_res_to_listings
    highest_ratio = 0
    current_reservation_ratio = 0
    nabe_with_highest_reservation_ratio = nil
    self.all.each do |neighborhood|
      current_reservation_ratio = neighborhood.reservations.count.to_f / neighborhood.listings.count if neighborhood.listings.count > 0
      if highest_ratio < current_reservation_ratio
        highest_ratio = current_reservation_ratio
        nabe_with_highest_reservation_ratio = neighborhood
      end
    end
    nabe_with_highest_reservation_ratio
  end

  def self.most_res
    most_reservation_count = 0
    current_reservation_count = 0
    nabe_with_most_reservation = nil
    self.all.collect do |neighborhood|
      current_reservation_count = neighborhood.reservations.count
      if most_reservation_count < current_reservation_count
        most_reservation_count = current_reservation_count
        nabe_with_most_reservation  = neighborhood
      end
    end
    nabe_with_most_reservation
  end
end
