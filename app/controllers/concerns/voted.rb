module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_voteable, only: [:vote_up, :vote_down, :vote_reset]
  end

  def vote_up
    return render_no_permission unless can?(:vote_up, @voteable)
    @vote = @voteable.vote_up(current_user)
    render_json
  end

  def vote_down
    return render_no_permission unless can?(:vote_down, @voteable)
    @vote = @voteable.vote_down(current_user)
    render_json
  end

  def vote_reset
    return render_no_permission unless can?(:vote_reset, @voteable)
    @vote = @voteable.vote_reset(current_user)
    render_reset
  end

  private

  def render_json
    respond_to do |format|
      if @vote.persisted?
        format.json { render json: { vote: "You are vote", value: @voteable.balance_votes } }
      else
        format.json { render json: @vote.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def render_no_permission
    respond_to do |format|
      format.json { render json: { vote: "You are not rights for this act" }, status: :forbidden }
    end
  end

  def render_reset
    respond_to do |format|
      format.json { render json: { vote: "Your vote has been canceled", value: @voteable.balance_votes }}
    end
  end

  def get_klass
    controller_name.classify.constantize
  end

  def set_voteable
    @voteable = get_klass.find(params[:id])
  end
end
