module Voted
  extend ActiveSupport::Concern

  included do
    before_action :vote_init, only: [:vote_up, :vote_down]
  end

  def vote_up
    @vote.voteup = true
    vote_response
  end

  def vote_down
    vote_response
  end

  def vote_reset
    set_voteable
    if current_user && !current_user&.owner?(@voteable) && !@voteable.can_vote?(current_user)
      @vote = @voteable.user_vote(current_user)

      respond_to do |format|
        if @vote.destroy
          format.json do
            render json: { vote: "You vote destroy" }.to_json
          end
        else
          format.json do
            render json: @vote.errors.full_messages, status: :unprocessable_entity
          end
        end
      end
    else

    end
  end

  private

  def vote_response
    respond_to do |format|
      if @vote.save
        format.json do
          render json: { vote: "You voted" }.to_json
        end
      else
        format.json do
          render json: @vote.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  def vote_init
    set_voteable
    if current_user && !current_user&.owner?(@voteable) && @voteable.can_vote?(current_user)
      @vote = Vote.new(voteable: @voteable, user: current_user)
    else
      respond_to do |format|
        format.json { render json: { vote: "You do not have rights to act" }.to_json, status: 401}
      end
    end
  end

  def get_klass
    controller_name.classify.constantize
  end

  def set_voteable
    @voteable = get_klass.find(params[:id])
  end
end
