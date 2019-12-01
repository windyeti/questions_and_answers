class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable, only: [:create]

  authorize_resource

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_commentable
    @commentable = set_name.classify.constantize.find(params["#{set_name.singularize}_id"])
  end

  def set_name
    params[:commentable]
  end
end
