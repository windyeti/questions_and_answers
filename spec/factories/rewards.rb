FactoryBot.define do
  factory :reward do
    name { "My reward for best answer" }
    question { nil }

    trait :with_picture do
      picture { fixture_file_upload(Rails.root.join('spec', 'support', 'images', 'marty.jpg'), 'image/jpg') }
    end

    # trait :with_picture do
    #   picture { fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'text/plain') }
    # end

    # trait :with_picture do
    #   after :create do |reward|
    #     file_path1 = Rails.root.join('spec', 'rails_helper.rb')
    #     file1 = fixture_file_upload(file_path1, 'text/plain')
    #     reward.picture.attach(file1)
    #   end
    # end
  end
end
