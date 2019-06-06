FactoryBot.define do
  factory :answer do
    question { nil }
    body { "MyText" }
    best { false }
  end
end
