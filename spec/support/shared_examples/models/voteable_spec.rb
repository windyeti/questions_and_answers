require 'rails_helper'

shared_examples_for 'voteable' do
  let(:model) { described_class }
  let(:user) { create(:user) }
  let(:voteable) { create(model.to_s.underscore.to_sym) }
  let!(:vote) { create(:vote, voteable: voteable, user: user) }

  it 'can_vote?' do
    expect(voteable.can_vote?(user)).to be_falsey
  end
  it 'has_vote?' do
    expect(voteable.has_vote?(user)).to be_truthy
  end
  it { should have_many(:votes).dependent(:destroy) }
end
