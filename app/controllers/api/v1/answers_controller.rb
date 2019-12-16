class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource except: :destroy

  before_action :find_question, only: [:index, :create]
  before_action :find_answer, only: [:show, :update, :destroy]

  def index
    # for test we need reorder which build default_scope
    @answers = @question.answers.reorder(id: :asc)
    render json: @answers
  end

  def show
    render json: @answer, serializer: SingleAnswerSerializer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner
    if @answer.save
      head :ok
    else
      render json: { errors_message: @answer.errors.full_messages, status: :forbidden }, status: :forbidden
    end
  end

  def update
    if @answer.update(answer_params)
      head :ok
    else
      render json: { errors_message: @answer.errors.full_messages, status: :forbidden }, status: :forbidden
    end
  end

  def destroy
    authorize! :destroy, @answer

    if @answer.destroy
      head :ok
    else
      render json: { errors_message: @answer.errors.full_messages, status: :forbidden }, status: :forbidden
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(
                                    :body,
                                    links_attributes: [:id, :name, :url, :_destroy]
                                  )
  end
end
