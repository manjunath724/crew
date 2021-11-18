class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :votes

  validates_presence_of :name

  # Check whether User has already cast vote for a given member
  # Used to prevent duplicate votes or actions performed on expired session
  def has_cast_vote?(member_id)
    votes.find_by_member_id(member_id).present?
  end
end
