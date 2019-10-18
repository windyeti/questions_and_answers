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

    trait :with_attachment do
      after :create do |question|
        file_path1 = Rails.root.join('spec', 'rails_helper.rb')
        file1 = fixture_file_upload(file_path1, 'text/plain')
        file_path2 = Rails.root.join('spec', 'spec_helper.rb')
        file2 = fixture_file_upload(file_path2, 'text/plain')
        question.files.attach([file1, file2])
      end
    end


    trait :with_links do
      after :create do |question|
        link1 = Link.create(name: 'Google', url: 'https://google.com')
        link2 = Link.create(name: 'Rbk', url: 'https://rbk.ru')
        question.links << [link1, link2]
      end
    end

    trait :with_reward do
      after :create do |question|
        reward = question.build_reward
        reward.name = 'My reward for best answer'
        reward.picture = fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'text/plain')
        reward.save
      end
    end
  end
end
