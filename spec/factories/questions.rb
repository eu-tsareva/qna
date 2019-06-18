FactoryBot.define do
  factory :question do
    user
    sequence(:title) { |n| "Question Title - #{n}" }
    sequence(:body) { |n| "Question Body - #{n}" }

    trait :invalid do
      title { nil }
    end
  end
end
