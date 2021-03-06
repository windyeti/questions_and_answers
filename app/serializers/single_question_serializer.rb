class SingleQuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :files
  has_many :comments
  has_many :links

  def files
    object.files.map do |f|
      rails_blob_path(f, only_path: true)
    end
  end
end
