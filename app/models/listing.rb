class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :listing_type, :address, :price, :description, :neighborhood_id, :title, presence: true

  after_save :update_host_status
  after_destroy :update_host_status

  def available?(start_date, end_date)
    self.class.available(start_date, end_date).include?(self)
  end

  def average_review_rating
    reviews.average(:rating)
  end

  private

  def update_host_status
    host.update_host_status
  end

  def self.available(start_date, end_date)
    query = <<~SQL
      SELECT DISTINCT listings.*
        FROM listings
        LEFT JOIN (
          SELECT listings.id
          FROM listings
          JOIN reservations
          ON listings.id = reservations.listing_id
          WHERE :start_date BETWEEN reservations.checkin AND reservations.checkout
          OR :end_date BETWEEN reservations.checkin AND reservations.checkout
        ) AS booked
        ON listings.id = booked.id
       WHERE booked.id IS NULL
    SQL
    self.find_by_sql [query, {start_date: start_date, end_date: end_date}]
  end

  def self.most_res
    query = <<~SQL
      SELECT listings.*, count(*) as res_count
      FROM listings
      LEFT JOIN reservations
      ON listings.id = reservations.listing_id
      GROUP BY listings.id
      ORDER BY res_count DESC
      LIMIT 1
    SQL
    self.find_by_sql [query]
  end
end
