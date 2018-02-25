class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :host_isnt_guest

  def host_isnt_guest
      if host_id == guest_id
          errors.add(:reservation, "Host can't book their own listing.")
      end
  end
end
