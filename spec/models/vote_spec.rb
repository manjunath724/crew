require 'rails_helper'

RSpec.describe Vote, type: :model do
  subject { build(:vote) }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a member" do
    subject.member = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a user" do
    subject.user = nil
    expect(subject).to_not be_valid
  end

  it "is not valid with duplicate information" do
    subject = create(:vote).dup
    expect(subject).to_not be_valid
  end
end
