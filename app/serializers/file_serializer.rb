class FileSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :url

  def url
    p '+++++++++++++++++++++++++'
    p rails_blob_path(object, only_path: true)
    p '>>>>>>>>>>>>>>>>>>'
    p '+++++++++++++++++++++++++'
  end
end
