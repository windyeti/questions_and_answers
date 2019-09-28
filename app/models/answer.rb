class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  default_scope { order(best: :desc).order(created_at: :desc) }

  def set_best
    transaction do
      question.answers.each { |answer_best| answer_best.update!(best: false) }
      update!(best: true)
    end
  end
end
