FactoryBot.define do
  factory :answer do
    body { "MyBody" }
    correct { false }
    question { nil }
  end
end
