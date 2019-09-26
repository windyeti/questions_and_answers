class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:destroy, :edit, :update, :best]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
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
    if current_user&.owner?(@answer.question)
      @answer.all_best_false
      @answer.update(best: true)
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
