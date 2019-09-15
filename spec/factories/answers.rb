FactoryBot.define do
  factory :answer do
    body { "MyBody" }
    question
    user

    trait :invalid do
      body { nil }
    end
  end
end
