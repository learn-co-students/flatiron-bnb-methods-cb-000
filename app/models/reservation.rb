class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  before_create :set_errors

  validates :checkin, presence: true
  validates :checkout, presence: true

    validate :check_in
    validate :check_out?
    validate :available?

  def duration
    dif = checkout - checkin
    dif.to_i
  end

  def total_price
    self.duration * self.listing.price.to_i
  end

  private

  def set_errors
    @errors = ActiveModel::Errors.new(self)
  end

  def check_out?
    if !self.listing.neighborhood.neighborhood_openings(checkin, checkin).include?(self.listing)
      @errors.add(:checkout, "not available at check out")
    end
  end

  def check_in
    if !self.listing.neighborhood.neighborhood_openings(checkin, checkin).include?(self.listing)
      @errors.add(:checkin, "not available at check in")
    end
    if checkout == checkin
      @errors.add(:checkin, "checkin and checkout can't be the same day")
    end
    if intize(checkout) < intize(checkin)
      @errors.add(:checkin, "Checkout must be after checkin")
    end
  end

  def available?
    if !self.listing.neighborhood.neighborhood_openings(checkin, checkout).include?(self.listing)
      @errors.add(:checkin, "not available for those dates")
    end
    if self.listing.host.id == self.guest_id
      @errors.add(:checkin, "Can't reserve somewhere you own")
    end
  end



end
