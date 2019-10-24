require 'rails_helper'

shared_examples_for 'voteable' do
  let(:model) { described_class }
  let(:user) { create(:user) }
  let(:voteable) { create(model.to_s.underscore.to_sym) }
  let!(:vote) { create(:vote, voteable: voteable, user: user) }
  let(:voteable_for_votes_list) { create(model.to_s.underscore.to_sym) }
  let!(:votes_list) { create_list(:vote, 5, voteable: voteable_for_votes_list, voteup: true) }

  it 'can_vote?' do
    expect(voteable.can_vote?(user)).to be_falsey
  end
  it 'user_vote' do
    expect(voteable.user_vote(user)).to be_truthy
  end
  it { should have_many(:votes).dependent(:destroy) }
  it 'balance_votes' do
    expect(voteable_for_votes_list.balance_votes).to eq 5
  end
end
