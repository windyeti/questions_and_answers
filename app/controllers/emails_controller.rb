class EmailsController < ApplicationController
  skip_authorization_check

  def new; end

  def create
    @user = User.create_user_and_auth!(email_params, params[:provider], params[:uid])

    if @user
      redirect_to new_user_session_path, notice: 'Check your email for confirmation instructions'
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  private

  def email_params
    params.require(:email)
  end
end
