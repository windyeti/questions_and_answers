class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files, dependent: :destroy

  accepts_nested_attributes_for :links

  validates :title, :body, presence: true
end
