class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :destroy]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: "New question created"
    else
      render :new
    end
  end

  def show
    @answer = Answer.new
  end

  def destroy
    if current_user_owner_question?
      flash[:notice] = "Question have been delete."
      @question.delete
    end

    redirect_to questions_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def find_question
    @question = Question.find(params[:id])
  end

  def current_user_owner_question?
    @question.user.email == current_user.email
  end
end
