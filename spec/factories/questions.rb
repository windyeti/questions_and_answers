FactoryBot.define do
  sequence :num do |n|
    "#{n}"
  end
  factory :question do
    title { "MyTitle_#{generate(:num)}" }
    body { "MyBody #{generate(:num)}" }
    trait :invalid do
      body { nil }
    end
  end
end
