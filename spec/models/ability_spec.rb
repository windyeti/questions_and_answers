require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'Admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to(:manage, :all) }

  end

  describe 'Guest' do
    let(:user) { nil }

    %w[Question Answer Comment].each do |resource|
      it { should be_able_to(:read, resource.constantize) }
    end

    it { should_not be_able_to(:manage, :all) }

  end

  describe 'User' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other_user) }

    %w[Question Answer Comment].each do |resource|
      it { should be_able_to(:read, resource.constantize) }
    end

    it { should_not be_able_to(:manage, :all) }

    %w[Question Answer Comment].each do |resource|
      it { should be_able_to(:create, resource.constantize) }
    end

    %i[question answer].each do |resource|
      it { should be_able_to(:update, create(resource, user: user)) }
      it { should_not be_able_to(:update, create(resource, user: other_user)) }
    end

    %i[question answer].each do |resource|
      it { should be_able_to(:destroy, create(resource, user: user)) }
      it { should_not be_able_to(:destroy, create(resource, user: other_user)) }
    end

    it { should be_able_to(:best, create(:answer, question: question, user: other_user)) }
    it { should_not be_able_to(:best, create(:answer, user: other_user)) }

    %i[question answer].each do |resource|
      %i[vote_up vote_down].each do |action|
        it { should be_able_to(action, create(resource, user: other_user)) }
        it { should_not be_able_to(action, create(resource, user: user)) }
      end
    end
    describe 'resource already voted' do
      %i[question answer].each do |resource|
        let(:other_voteable) { create(resource, user: other_user) }
        let!(:vote) { create(:vote, user: user, value: 1, voteable: other_voteable) }

        it { should be_able_to(:vote_reset, other_voteable) }
      end
    end

    it { should be_able_to(:destroy, ActiveStorage::Attachment) }
    it { should_not be_able_to(:destroy, ActiveStorage::Attachment.new(record: other_question)) }

    it { should be_able_to(:destroy, create(:link, linkable: question)) }
    it { should_not be_able_to(:destroy, create(:link, linkable: other_question)) }

    it { should be_able_to(:user_rewards, create(:reward, question: question)) }
    it { should_not be_able_to(:user_rewards, create(:reward, question: other_question)) }

    it { should be_able_to(:me, User) }
    it { should be_able_to(:index, User) }

  end
end
