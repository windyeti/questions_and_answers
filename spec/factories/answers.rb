FactoryBot.define do
  factory :answer do
    body { "MyBody" }
    question { nil }

    trait :invalid do
      body { nil }
    end
  end
end
