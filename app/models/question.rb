class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :delete_all

  has_many_attached :files

  validates :title, :body, presence: true
end
