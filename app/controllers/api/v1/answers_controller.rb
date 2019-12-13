class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource
  before_action :find_question, only: [:index]
  before_action :find_answer, only: [:show]

  def index
    # for test we need reorder which build default_scope
    @answers = @question.answers.reorder(id: :asc)
    render json: @answers
  end

  def show
    render json: @answer, serializer: SingleAnswerSerializer
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
