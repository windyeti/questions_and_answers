class AnswersController < ApplicationController
  before_action :find_answer, only: [:show]
  before_action :find_question, only: [:create]

  # def new
  #   # @answer = Answer.new
  # end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to @question
    else
      render 'questions/show'
    end
  end

  # def show
  #
  # end

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
