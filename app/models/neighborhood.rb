class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    date_range = ( start_date .. end_date ).to_a
    return nil if start_date >= end_date

    open_listings = []
    self.listings.map do |l|
      dates_available = l.available(start_date, end_date)
      open_listings << l if date_range.all?{ |date| dates_available.include?(date)}
    end

     open_listings
  end

  # start_date = Date.parse('2014-01-09'); end_date = Date.parse('2014-04-27')
  # start_date = Date.parse('2014-01-21'); end_date = Date.parse('2014-04-26')
  # l.reservations.map{|r| "#{r.checkin} - #{r.checkout}"}
  # n.listings.map{|l| l.print_reserved_dates}

  def self.highest_ratio_res_to_listings
    ratio_arr = all.map do |neighborhood|
      listings_count = neighborhood.listings.count.to_f
      reservations_count = neighborhood.listings.map{|l| l.reservations.count}.inject(0, :+).to_f
      ratio = listings_count == 0 ? 0 : reservations_count / listings_count
      [neighborhood.name, ratio]
    end.to_h

    highest_ratio_name = ratio_arr.max_by{|k,v| v}.first

    Neighborhood.find_by_name(highest_ratio_name)
  end

  def self.most_res
    res_arr = all.map do |neighborhood|
      reservations_count = neighborhood.listings.map{|l| l.reservations.count}.inject(0, :+)
      [neighborhood.name, reservations_count]
    end.to_h

    most_res_name = res_arr.max_by{|k,v| v}.first

    Neighborhood.find_by_name(most_res_name)
  end

end
