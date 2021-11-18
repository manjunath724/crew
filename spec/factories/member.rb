FactoryBot.define do
  # Create a Member record
  factory :member do
    name { Faker::Name.unique.name }
    title { Faker::Job.title }
    bio { Faker::Company.catch_phrase + Faker::Company.bs }

    # Create a Member with associated votes
    factory :member_with_votes do
      transient do
        votes_count { Faker::Number.digit }
      end

      votes do
        Array.new(votes_count) { association(:vote) }
      end
    end
  end
end
