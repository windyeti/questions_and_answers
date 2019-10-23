module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_voteable, only: [:create_vote]
  end

  def create_vote
    if !current_user&.owner?(@voteable) && @voteable.can_vote?(current_user)
      @vote = Vote.new(voteable: @voteable, user: current_user)
      respond_to do |format|
        if @vote.save
          format.json do
            render json: { "text": "reset vote" }
          end
        else
          format.json do
            render json: @voteable.errors.full_messages, status: :unprocessable_entity
          end
        end
      end
    end
  end

  private

  def get_klass
    controller_name.classify.constantize
  end

  def set_voteable
    @voteable = get_klass.find(params[:id])
  end
end
