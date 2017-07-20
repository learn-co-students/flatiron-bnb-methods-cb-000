class ReviewValidator < ActiveModel::Validator


  def validate(record)

     if (Time.now < record.reservation.checkout)

         record.errors[:review] << "must be completed after checkout."
       end
  end


end
