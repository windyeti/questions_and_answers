class EmailsController < ApplicationController
  def new; end

  def create
    begin
      User.transaction do
        password = Devise.friendly_token[0, 20]
        @user = User.create!(email: email_params, password: password, password_confirmation: password)
        @user.authorizations.create!(provider: params[:provider], uid: params[:uid])
      end
    rescue
      false
    end

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
