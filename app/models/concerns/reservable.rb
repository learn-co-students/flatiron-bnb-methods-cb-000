module Reservable
   module InstanceMethods
     def all_reservations
       total_reservations = listings.collect do |listing|
         listing.reservations.size
       end
       total_reservations.sum
     end
   end

   module ClassMethods
     def highest_ratio_res_to_listings
       listings_array = self.all.select { |element| !element.listings.empty? } # find all non-empty models of the current model
       listings_array.max { |first, second| first.all_reservations/first.listings.size <=> second.all_reservations/second.listings.size} # compare each element in non-empty listing array
     end

     def most_res
       all.max { |first, second|  first.all_reservations <=> second .all_reservations }
     end
   end
end
