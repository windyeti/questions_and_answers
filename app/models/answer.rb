class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  default_scope { order(best: :desc) }

  def all_best_false
    Answer.where('best = true').update(best: false)
  end

end
