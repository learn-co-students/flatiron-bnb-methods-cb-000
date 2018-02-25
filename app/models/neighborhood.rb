class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def self.most_res
      self.all.max_by do |neighborhood|
          neighborhood.reservations.count
      end
  end

  def self.highest_ratio_res_to_listings
      self.all.max_by do |neighborhood|
          if neighborhood.listings.count > 0
              neighborhood.reservations.count / neighborhood.listings.count
          else
              0
          end
      end
  end

  def neighborhood_openings(checkin, checkout)
      available_listings = []
      self.listings.each do |listing|
          available_listings << listing if listing.available?(checkin, checkout)
      end
      available_listings
  end

end
