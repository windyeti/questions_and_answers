FactoryBot.define do
  factory :reward do
    name { "My reward for best answer" }
    question { nil }

    trait :with_picture do
      picture { fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'text/plain') }
    end
  end
end
