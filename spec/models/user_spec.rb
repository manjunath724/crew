require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a name" do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without an email" do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a password" do
      subject.password = nil
      expect(subject).to_not be_valid
    end

    it "has voted" do
      digit = Faker::Number.digit
      len = build(:user_with_votes, votes_count: digit).votes.length
      expect(len).to eq(digit)
    end

    it "has cast vote" do
      vote = create(:vote)
      expect(vote.user.has_cast_vote?(vote.member_id)).to be_truthy
    end

    it "is not valid with duplicate information" do
      subject.email = create(:user).email
      expect(subject).to_not be_valid
    end
  end
end
