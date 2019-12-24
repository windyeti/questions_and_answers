class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:destroy]

  authorize_resource

  def create
    @subscription = current_user.subscriptions.create(question_id: params_subscription)
  end

  def destroy
    @subscription = current_user.subscriptions.find_by(question_id: @question.id)
    @subscription.destroy
  end

  private

  def params_subscription
    params.require(:id)
  end

  def find_question
    @question = Question.find(params_subscription)
  end
end
