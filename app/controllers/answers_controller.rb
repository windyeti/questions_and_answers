class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question, notice: "Answer have been successfully created."
    else
      flash.now[:alert] = "Answer was not created."
      render 'questions/show'
    end
  end

  def destroy
    if current_user.owner?(@answer)
      @answer.destroy
      flash[:notice] = "Answer have been deleted."
    else
      flash[:alert] = "Answer was not deleted."
    end
      redirect_to @answer.question
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
