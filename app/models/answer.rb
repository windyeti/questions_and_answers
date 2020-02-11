class Answer < ApplicationRecord
  include Rails.application.routes.url_helpers

  include Voteable

  belongs_to :question, touch: true
  belongs_to :user

  has_many :links, dependent: :destroy, as: :linkable, inverse_of: :linkable
  has_many :comments, dependent: :destroy, as: :commentable, inverse_of: :commentable

  has_many_attached :files, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  after_create :publish_answer, :notify_of_answer

  default_scope { order(best: :desc).order(created_at: :desc) }

  def set_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      user.rewards << question.reward if question.reward.present?
    end
  end

  def publish_answer
    ActionCable.server.broadcast(
      "answers_question_#{question.id}",
      answer_id: id,
      answer_user_id: user_id,
      answer_body: body,
      answer_best: best,
      answer_balance_votes: balance_votes,
      answer_links: attachment_links(links),
      answer_files: attachment_files(files)
    )
  end

  def attachment_files(files)
    files.map do |f|
      {
        id: f.id,
        url: rails_blob_path(f, only_path: true),
        name: f.filename.to_s
      }
    end
  end

  def attachment_links(links)
    links.map do |f|
      {
        id: f.id,
        url: f.url,
        name: f.name
      }
    end
  end

  def notify_of_answer
    AnswerNotificationJob.perform_later(self)
  end
end
