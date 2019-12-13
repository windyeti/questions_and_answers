class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource
  before_action :find_question, only: [:index]

  def index
    # for test we need reorder which build default_scope
    @answers = @question.answers.reorder(id: :asc)
    render json: @answers
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end
end
