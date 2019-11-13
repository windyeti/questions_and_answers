class Question < ApplicationRecord
  include Voteable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable, inverse_of: :linkable
  has_many :comments, dependent: :destroy, as: :commentable, inverse_of: :commentable

  has_one :reward, dependent: :destroy, inverse_of: :question

  has_many_attached :files, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  after_create :publish_question, only: :create

  def publish_question
    ActionCable.server.broadcast(
      'questions',
      question_id: id,
      question_title: title,
      question_body: body,
      question_user_id: user_id
    )
  end
end
