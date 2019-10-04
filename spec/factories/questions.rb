# include ActionDispatch::TestProcess

FactoryBot.define do
  sequence :num do |n|
    "#{n}"
  end
  factory :question do
    title { "MyTitle_#{generate(:num)}" }
    body { "MyBody #{generate(:num)}" }
    user

    trait :invalid do
      body { nil }
    end

    trait :with_attached do
      after :create do |question|
        file_path1 = Rails.root.join('spec', 'rails_helper.rb')
        file1 = fixture_file_upload(file_path1, 'text/plain')
        file_path2 = Rails.root.join('spec', 'spec_helper.rb')
        file2 = fixture_file_upload(file_path2, 'text/plain')
        question.files.attach([file1, file2])
      end
    end
  end
end
