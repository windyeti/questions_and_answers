class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_file, only: [:destroy]

  def destroy
    authorize! :destroy, @file
    # return unless current_user.owner?(@file.record)

    @file.purge
  end

  private

  def find_file
    @file = ActiveStorage::Attachment.find(params[:id])
  end
end
