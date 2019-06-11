FactoryBot.define do
  factory :answer do
    question
    body { "MyText" }
    best { false }

    trait :invalid do
      body { nil }
    end
  end
end
