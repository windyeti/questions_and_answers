class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, [Question, Answer, Comment]
    return unless user
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], { user: user }
    can :destroy, [Question, Answer], { user: user }
    can :best, Answer,  question: { user_id: user.id }
    can [:vote_up, :vote_down], [Question, Answer] do |resource|
      !user.owner?(resource) && resource.can_vote?(user)
    end
    can :vote_reset, [Question, Answer] do |resource|
      !user.owner?(resource) && resource.can_reset?(user)
    end
    can :destroy, ActiveStorage::Attachment, record: { user_id: user.id }
    # can :destroy, ActiveStorage::Attachment do |file|
    #   user.owner?(file.record)
    # end
    can :destroy, Link, linkable: { user_id: user.id }
    can :user_rewards, Reward, question: { user_id: user.id }
  end
end
