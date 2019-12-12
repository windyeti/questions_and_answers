class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource
  before_action :find_question, only: [:show]

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question, serializer: SingleQuestionSerializer
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end
end
