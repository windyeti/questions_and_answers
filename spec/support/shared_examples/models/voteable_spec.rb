require 'rails_helper'

shared_examples_for 'voteable' do
  let(:model) { described_class }
  let(:user) { create(:user) }
  let!(:voteable) { create(model.to_s.underscore.to_sym) }

  it { should have_many(:votes).dependent(:destroy) }

  describe '' do
    let!(:vote) { create(:vote, voteable: voteable, user: user) }

    it 'can_vote?' do
      expect(voteable.can_vote?(user)).to be_falsey
    end

    it 'can_reset?' do
      expect(voteable.can_reset?(user)).to be_truthy
    end

    it 'user_vote' do
      expect(voteable.user_vote(user)).to be_truthy
    end
  end

  describe 'increment, decrement, reset' do

    it 'vote_increment' do
      expect do
        voteable.vote_increment(user)
      end.to change(voteable.votes, :count).by(1)
    end

    it 'vote_decrement' do
      expect do
        voteable.vote_decrement(user)
      end.to change(voteable.votes, :count).by(1)
    end

    it 'vote_reset' do
      voteable.vote_increment(user)

      expect do
        voteable.vote_reset(user)
      end.to change(voteable.votes, :count).by(-1)
    end
  end

  describe 'check sum value' do
    let(:voteable_for_votes_list) { create(model.to_s.underscore.to_sym) }
    let!(:votes_list) { create_list(:vote, 5, voteable: voteable_for_votes_list, value: 1) }

    it 'balance_votes' do
      expect(voteable_for_votes_list.balance_votes).to eq 5
    end
  end
end
