module Reservable
   module InstanceMethods
     def all_reservations
       total_reservations = listings.collect do |listing|
         listing.reservations.size
       end
       total_reservations.sum
     end

     def listing_ratio
       if listings.count > 0
         all_reservations.to_f / listings.count.to_f
       else
         0.0 # return a floating point of 0.0 to avoid nil ratio
       end
     end
   end

   module ClassMethods
     def highest_ratio_res_to_listings
     end

     def most_res
       all.max do |first, second|
         first.all_reservations <=> second .all_reservations
       end
     end
   end
end
