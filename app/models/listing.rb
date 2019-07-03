class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood_id, presence: true

  # before_validation :change_host_status
  # validate :is_host_true?

  # def is_host_true?
  #   self.host_id
  # end

  def average_review_rating
    self.reviews.average(:rating)
  end

  private

  # def change_host_status
  #   self.host.host = true
  #   self.host.save
  # end

  # def is_a_neighborhood?
  #   Neighborhood.all.any? { |n_id| n_id == neighborhood_id }
  # end

end
