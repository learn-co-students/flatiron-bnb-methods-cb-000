class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(date_begin, date_end)
    self.listings.find_all do |listing|
      listing.available?(date_begin, date_end)
    end
  end

  def self.highest_ratio_res_to_listings
    hash_of_ratios = {}
    Neighborhood.all.each do |neighborhood|
      if !neighborhood.listings.empty?
        hash_of_ratios[neighborhood] = neighborhood.number_of_reservations.to_f/neighborhood.listings.size
      end
    end
    hash_of_ratios.sort_by {|neighborhood, ratio| ratio}.reverse[0][0]
  end

  def number_of_reservations
    array_of_reservations = self.listings.map {|listing| listing.number_of_reservations}
    array_of_reservations.sum {|reservation_count| reservation_count}
  end

  def self.most_res
    neighborhood_reservations = {}
    Neighborhood.all.each do |neighborhood|
      neighborhood_reservations[neighborhood] = neighborhood.number_of_reservations
    end
    neighborhood_reservations.sort_by {|neighborhood, reservation_count| reservation_count}.reverse[0][0]
  end
end
