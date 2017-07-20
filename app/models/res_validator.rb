class ResValidator < ActiveModel::Validator

  def validate(record)
    if record.listing.id == record.guest.id
      record.errors[:listing] << "Can't reserve your own listing"
    end
  end



end
