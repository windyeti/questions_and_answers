class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :destroy, :edit, :update]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
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

  def edit; end

  def update
    @question.update(question_params)
  end

  def destroy
    if current_user.owner?(@question)
      @question.destroy
      flash[:notice] = "Question have been deleted."
    else
      flash[:alert] = "Question have not been deleted. You are not owner of the question."
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
end
