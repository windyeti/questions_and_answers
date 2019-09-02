FactoryBot.define do
  factory :answer do
    body { "MyBody" }
    correct { false }
    question { nil }

    trait :invalid do
      body { nil }
    end
  end
end
