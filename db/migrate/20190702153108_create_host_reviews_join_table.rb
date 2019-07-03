class CreateHostReviewsJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_table :host_reviews do |t|
      t.integer :host_id
      t.integer :review_id
      # t.index [:host_id, :guest_id]
      # t.index [:guest_id, :host_id]
    end
  end
end
