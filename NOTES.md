reservation.checkin <= checkin && reservation.checkout >= checkout

reservation.checkin <= checkout && reservation.checkout >= checkin
  Fails if:
    another guest checks in on or before the day I check out
      AND
    that guest checks out on or after the day I check in

    e.g.  reservation.checkout checkin   reservation.checkin checkout
          July 1                July 15  July 30              Aug 1
