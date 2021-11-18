require 'rails_helper'

RSpec.describe Member, type: :model do
  subject { build(:member) }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a title" do
    subject.title = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a description" do
    subject.bio = nil
    expect(subject).to_not be_valid
  end

  it "has votes" do
    digit = Faker::Number.digit
    len = build(:member_with_votes, votes_count: digit).votes.length
    expect(len).to eq(digit)
  end
end
