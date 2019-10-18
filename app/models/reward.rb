class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  has_one_attached :picture, dependent: :destroy

  validates :name, presence: true
end
