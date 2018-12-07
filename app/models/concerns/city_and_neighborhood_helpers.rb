module CityAndNeighborhoodHelpers
  def self.included base
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  module InstanceMethods
    def openings(start_date, end_date)
      @available_listings = []
      @start = Date.parse start_date
      @end = Date.parse end_date
      self.listings.each do |l|
        @good = true
        l.reservations.each do |lr|
          (@start <= lr.checkout) && (@end >= lr.checkin) ? (@good = false) : nil
        end
        @good ? (@available_listings << l) : nil
      end
      @available_listings
    end
  end

  module ClassMethods
    def highest_ratio_res_to_listings
      @top_ratio = 0.00
      self.all.each do |c|
        c.listings.each do |cl|
          @ratio = cl.reservations.count / c.listings.count
          if @top_ratio < @ratio
            @top_ratio = @ratio
            @city = c
          end
        end
      end
      return @city
    end

  def most_res
    @top_res = 0
    self.all.each do |c|
      c.listings.each do |cl|
        @city_res = cl.reservations.count
        if @top_res < @city_res
          @top_res = @city_res
          @city = c
        end
      end
    end
    return @city
  end
end
end
