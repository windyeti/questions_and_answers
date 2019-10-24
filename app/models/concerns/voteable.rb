module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :voteable
  end

  def can_vote?(user)
    !user_vote(user)
  end

  def user_vote(user)
    votes.find_by(user_id: user.id)
  end

  def balance_votes
    2 * votes.where(voteup: true).count - votes.count
  end
end
