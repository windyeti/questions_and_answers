FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end
  factory :user do
    email
    password { '123456' }
    password_confirmation { '123456' }

    # after(:build)   { |u| u.skip_confirmation_notification! }
    after(:create)  { |u| u.confirm }
  end
end
