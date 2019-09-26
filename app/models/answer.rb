class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  validates_inclusion_of :best, in: [true, false]

  default_scope { order(best: :desc) }

  def all_best_false
    Answer.where('best = true').update(best: false)
  end

end
