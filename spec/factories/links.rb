FactoryBot.define do
  factory :link do
    linkable { nil }
    name { "Google" }
    url { "http://google.ru" }
  end
end
