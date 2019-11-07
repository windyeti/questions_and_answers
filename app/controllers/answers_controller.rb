class AnswersController < ApplicationController
  include Voted

  # include Rails.application.routes.url_helpers


  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:destroy, :edit, :update, :best]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
    ActionCable.server.broadcast(
      "answers_question_#{@question.id}",
      answer: @answer,
      answer_balance_votes:  @answer.balance_votes,
      answer_links:  @answer.links,
      answer_files:  file_url(@answer.files)
    )
  end

  def file_url(files)
    files.map do |f|
      {
        id: f.id,
        url: rails_blob_path(f, only_path: true),
        name: f.filename.to_s
      }
    end

  end

  def edit
    redirect_to @answer.question unless current_user&.owner?(@answer)

  end

  def update
    redirect_to @answer.question unless current_user&.owner?(@answer)
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy if current_user&.owner?(@answer)
  end

  def best
    @answer.set_best if current_user&.owner?(@answer.question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end
end
