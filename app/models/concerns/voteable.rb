module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :voteable
  end

  def vote_up(user)
    votes.create(user: user, value: 1)
  end

  def vote_down(user)
    votes.create(user: user, value: -1)
  end

  def vote_reset(user)
    votes.find_by(user_id: user.id).destroy
  end

  def can_vote?(user)
    user && !user&.owner?(self) && !user_vote(user)
  end

  def can_reset?(user)
    user && !user&.owner?(self) && user_vote(user)
  end

  def user_vote(user)
    votes.find_by(user_id: user.id)
  end

  def balance_votes
    votes.sum(:value)
  end
end
