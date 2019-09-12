class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user.id
    if @answer.save
      redirect_to @question, notice: "Answer have been successfully created."
    else
      # если не перезагрузить @question после невалидного answer,
      # то в @question.answers остается answer с кривыми данными,
      # и он ломает верстку
      @question.reload
      render 'questions/show'
    end
  end

  def destroy
    if current_user_owner_answer?
      flash[:notice] = "Answer have been deleted."
      @answer.destroy
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
    @answer.question.user == current_user
  end
end
