class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: User

  def index
    @profiles = User.where.not(id: current_resource_owner.id)
    render json: @profiles, each_serializer: ProfileSerializer
  end

  def me
    render json: current_resource_owner
  end

end
