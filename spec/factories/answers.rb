FactoryBot.define do
  factory :answer do
    body { "MyBody" }
    question
    user

    trait :invalid do
      body { nil }
    end

    trait :with_attachment do
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
