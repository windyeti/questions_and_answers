class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:destroy]

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to @question, notice: "Answer have been successfully created."
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user_owner_answer?
      flash[:notice] = "Question have been delete."
      @answer.delete
    end
    redirect_to @answer.question, notice: "Answer have been delete."
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

  def current_user_owner_answer?
    @answer.question.user.email == current_user.email
  end
end
