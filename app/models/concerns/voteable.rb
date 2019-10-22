module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :voteable
  end

  def can_vote?(user)
    !has_vote?(user)
  end

  def has_vote?(user)
    votes.find_by(user_id: user.id)
  end
end
