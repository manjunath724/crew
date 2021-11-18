class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :member, counter_cache: true # Auto increments 'votes_count' attribute value in Member table

  # For accessing 'User' and 'Member' attributes through 'Vote' object
  delegate :name, :email, to: :user, prefix: true
  delegate :name, :title, :bio, to: :member, prefix: true

  # Uniqueness check to prevent duplicate votes
  validates_uniqueness_of :member, scope: :user, message: "You have already cast your vote."
end
