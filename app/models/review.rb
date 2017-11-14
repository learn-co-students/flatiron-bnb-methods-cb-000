class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence:true
  validates :description, presence:true
  validates :reservation, presence:true

  #is invalid without an associated reservation, has been accepted, and checkout has happened (FAILED - 1)

end
