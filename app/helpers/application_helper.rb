module ApplicationHelper
    module InstanceMethods
        
    end

    module ClassMethods
        def highest_ratio_res_to_listings
            ratios = {}
            self.all.each do |model|
              reservations = 0
              listings = 0
              model.listings.each do |listing|
                listings += 1
                reservations += listing.reservations.length
              end
              ratios[model.name] = reservations / listings if listings != 0
            end
            self.find_by(name: ratios.max_by{|key, value| value}.first)
        end
        
          def most_res
            models_with_res = {}
            self.all.each do |model|
              reservations = 0
              model.listings.each do |listing|
                reservations += listing.reservations.length
              end
              models_with_res[model.name] = reservations
            end
            self.find_by(name: models_with_res.max_by{|key, value| value}.first)
        end
    end
end
