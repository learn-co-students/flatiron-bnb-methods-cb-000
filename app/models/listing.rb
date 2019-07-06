class Listing < ActiveRecord::Base

  # Associations
  belongs_to :neighborhood, required: true
  belongs_to :host, :class_name => "User"

  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  # Validations
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood_id, presence: true

  # Callbacks
  after_save :change_host_status
  before_destroy :unset_host_as_host


  def average_review_rating
    self.reviews.average(:rating)
  end

  private

  def change_host_status
    unless host.host?
      host.update(host: true)
    end
  end

  # If the listing gets destroyed this will be called up which
  # finds the host of the listing and finds out if the listing
  # is empty form the hosts listings. If it is empty this will
  # unset the user as a host.
  def unset_host_as_host
    if Listing.where(host: host).where.not(id: id).empty?
        host.update(host: false)
    end
  end
  # def is_a_neighborhood?
  #   Neighborhood.all.any? { |n_id| n_id == neighborhood_id }
  # end

end
