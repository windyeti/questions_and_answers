class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource except: :destroy

  before_action :find_question, only: [:show, :update, :destroy]

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question, serializer: SingleQuestionSerializer
  end

  def create
    @question = current_resource_owner.questions.new(question_params)
    if @question.save
      head :ok
    else
      render json: { errors_message: @question.errors.full_messages, status: :forbidden }, status: :forbidden
    end
  end

  def update
    if @question.update(question_params)
      head :ok
    else
      render json: { errors_message: @question.errors.full_messages, status: :forbidden }, status: :forbidden
    end
  end

  def destroy
    authorize! :destroy, @question

    if @question.destroy
      head :ok
    else
      render json: { errors_message: "#{@question.body} has not been deleted", status: :unprocessable_entity }, status: :unprocessable_entity
    end
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(
                                      :title,
                                      :body,
                                      links_attributes: [:id, :name, :url, :_destroy]
                                    )
  end
end
