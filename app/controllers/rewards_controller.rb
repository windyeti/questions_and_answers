class RewardsController < ApplicationController
  before_action :authenticate_user!

  def user_rewards
    @rewards = current_user.rewards
  end
end
