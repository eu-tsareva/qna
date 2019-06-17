FactoryBot.define do
  factory :answer do
    user
    question
    body { "MyAnswer" }
    best { false }

    trait :invalid do
      body { nil }
    end
  end
end
