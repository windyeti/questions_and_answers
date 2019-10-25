module WithVote
  def render_json_ok_response
    render json: Hash[:vote, "You are vote", :value, set_resource.balance_votes]
    # render json: { vote: "You are vote", value: @voteable.balance_votes }
  end

  def render_json_with_errors
    render json: @vote.errors.full_messages, status: :unprocessable_entity
  end

  def render_json_with_denied
    render json: { vote: "You are not rights for this act" }, status: 401
  end

  private

  def get_klass
    controller_name.classify.constantize
  end

  def set_resource
    get_klass.find(params[:id])
  end
end
