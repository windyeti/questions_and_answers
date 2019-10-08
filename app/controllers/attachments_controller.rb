class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    return unless current_user.owner?(@file.record)
    @file.purge
  end
end
