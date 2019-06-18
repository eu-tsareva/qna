FactoryBot.define do
  factory :answer do
    user
    question
    best { false }
    sequence(:body) { |n| "Answer Body - #{n}" }

    trait :invalid do
      body { nil }
    end
  end
end
