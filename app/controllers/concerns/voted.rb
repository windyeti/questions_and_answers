module Voted
  extend ActiveSupport::Concern
  include WithVote

  included do
    before_action :set_voteable, only: [:vote_up, :vote_down, :vote_reset]
  end

  def vote_up
    respond_to do |format|
      if current_user && !current_user&.owner?(@voteable) && @voteable.can_vote?(current_user)
        @vote = Vote.new(voteable: @voteable, user: current_user)
        @vote.voteup = true
        if @vote.save
          format.json { render_json_ok_response }
        else
          format.json { render_json_with_errors }
        end
      else
        format.json { render_json_with_denied }
      end
    end
  end

  def vote_down
    respond_to do |format|
      if current_user && !current_user&.owner?(@voteable) && @voteable.can_vote?(current_user)
        @vote = Vote.new(voteable: @voteable, user: current_user)
        if @vote.save
          format.json { render json: { vote: "You are vote", value: @voteable.balance_votes } }
        else
          format.json { render json: @vote.errors.full_messages, status: :unprocessable_entity }
        end
      else
        format.json { render json: { vote: "You are not rights for this act" }, status: 401 }
      end
    end
  end

  def vote_reset
    if current_user && !current_user&.owner?(@voteable) && !@voteable.can_vote?(current_user)
      @vote = @voteable.user_vote(current_user)

      respond_to do |format|
        if @vote.destroy
          format.json do
            render json: { vote: "You vote reset", value: @voteable.balance_votes  }.to_json
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

  # def vote_response
  #   respond_to do |format|
  #     if @vote.save
  #       format.json do
  #         render json: { vote: "You voted", value: @voteable.balance_votes }.to_json
  #       end
  #     else
  #       format.json do
  #         render json: @vote.errors.full_messages, status: :unprocessable_entity
  #       end
  #     end
  #   end
  # end

  # def vote_init
  #   set_voteable
  #   if current_user && !current_user&.owner?(@voteable) && @voteable.can_vote?(current_user)
  #     @vote = Vote.new(voteable: @voteable, user: current_user)
  #   else
  #     respond_to do |format|
  #       format.json { render json: { vote: "You do not have rights to act" }.to_json, status: 401}
  #     end
  #   end
  # end

  def get_klass
    controller_name.classify.constantize
  end

  def set_voteable
    @voteable = get_klass.find(params[:id])
  end
end
