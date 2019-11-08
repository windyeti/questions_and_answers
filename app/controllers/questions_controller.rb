class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :destroy, :edit, :update]


  def index
    @questions = Question.all
    gon.user_id = current_user&.id
  end

  def show
    @answer = Answer.new
    @answer.links.build
    gon.user_id = current_user&.id
    gon.question_id = @question.id
    gon.question_of_user_id = @question.user_id
  end

  def new
    @question = Question.new
    @question.links.build
    @question.build_reward
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Question have been created'
    else
      render :new
    end
  end

  def edit
    redirect_to questions_path unless current_user&.owner?(@question)
  end

  def update
    if current_user&.owner?(@question)
      @question.update(question_params)
    else
      redirect_to questions_path
    end
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
    params.require(:question).permit(:title, :body,
                                     files: [],
                                     links_attributes: [:id, :name, :url, :_destroy],
                                     reward_attributes: [:name, :picture])
  end

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
