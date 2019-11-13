class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, :user, presence: true

  after_create :publish_comment

  def publish_comment
    id_stream = "#{commentable_type.downcase == 'question' ? commentable_id : commentable.question.id}"
    stream = "comments_#{id_stream}"
    ActionCable.server.broadcast(
      stream,
      body: body,
      commentable_type: commentable_type.downcase,
      commentable_id: commentable_id,
      creator_id: user_id
    )
  end
end
