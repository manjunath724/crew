FactoryBot.define do
  # Create a User record
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.safe_email }
    password { Faker::Internet.password }

    # Create a User with associated votes
    factory :user_with_votes do
      transient do
        votes_count { Faker::Number.digit }
      end

      votes do
        Array.new(votes_count) { association(:vote) }
      end
    end
  end
end
