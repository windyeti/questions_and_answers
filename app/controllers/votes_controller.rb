class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    @vote = Vote.new(vote_params)
    respond_to do |format|
      if @vote.save
        format.json { render json: {body: 'reset vote' }.to_json }
      else
      end
    end
  end

  private

  # def vote_params
  #   #   params.require(:vote).permite(:voteable_type, :voteable_id)
  #   # end
end
