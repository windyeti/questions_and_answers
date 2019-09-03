FactoryBot.define do
  factory :question do
    title { "MyTitle" }
    body { "MyBody" }

    trait :invalid do
      body { nil }
    end
  end
end
