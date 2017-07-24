
[1mFrom:[0m /home/jgarcia-56534/code/labs/flatiron-bnb-methods-cb-000/app/models/city.rb @ line 22 City#city_openings:

     [1;34m5[0m: [32mdef[0m [1;34mcity_openings[0m(start_date, end_date)
     [1;34m6[0m:   all_listings = [1;36mself[0m.listings
     [1;34m7[0m:   openings = [] [1;34m# should include all listings that do not have a reservation[0m
     [1;34m8[0m:                 [1;34m# or do not fall in the date range[0m
     [1;34m9[0m:   all_listings.each [32mdo[0m |listing|
    [1;34m10[0m:     [1;34m# binding.pry[0m
    [1;34m11[0m:     [32mif[0m listing.reservations.empty?
    [1;34m12[0m:       openings << listing
    [1;34m13[0m:     [32melse[0m
    [1;34m14[0m:       overlaps = [1;36mfalse[0m
    [1;34m15[0m:       listing.reservations.each [32mdo[0m |reservation|
    [1;34m16[0m:         [32mif[0m (start_date.to_date <= reservation.checkout) && (reservation.checkin < end_date.to_date)
    [1;34m17[0m:           overlaps = [1;36mtrue[0m
    [1;34m18[0m:           binding.pry
    [1;34m19[0m:         [32mend[0m
    [1;34m20[0m: 
    [1;34m21[0m:         openings << listing [32mif[0m !openings.include?(listing) && overlaps == [1;36mfalse[0m
 => [1;34m22[0m:         binding.pry
    [1;34m23[0m:         overlaps = [1;36mfalse[0m
    [1;34m24[0m:       [32mend[0m
    [1;34m25[0m:     [32mend[0m
    [1;34m26[0m:   [32mend[0m
    [1;34m27[0m:   openings
    [1;34m28[0m: [32mend[0m

