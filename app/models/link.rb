class Link < ApplicationRecord
  GIST_URL_EXPRESSION = /^(http[s]?:\/\/)?gist.github.com\/[a-zA-Z0-9]+\/[a-z0-9]+$/

  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url, presence: true, url: true
  #
  def gist?(url)
    !!(GIST_URL_EXPRESSION =~ url)
  end
end
