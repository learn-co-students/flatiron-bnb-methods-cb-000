SELECT r.*, AVG(r.rcount) as ave_count
FROM (
  SELECT cities.*, count(*) as rcount
  FROM cities
  INNER JOIN neighborhoods
  ON cities.id = neighborhoods.city_id
  INNER JOIN listings
  ON neighborhoods.id = listings.neighborhood_id
  INNER JOIN reservations
  ON listings.id = reservations.listing_id
  GROUP BY listings.id
) AS r
GROUP BY r.id
ORDER BY ave_count DESC
LIMIT 1;
