class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth_provider
  end

  def vkontakte
    oauth_provider
  end

  private

  def oauth_provider
    return redirect_to root_path unless oauth_params

    @user = User.find_for_oauth(oauth_params)
    if @user
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: action_name.capitalize) if is_navigational_format?
    else
      session["devise.provider"] = oauth_params.provider
      session["devise.uid"] = oauth_params[:uid].to_s
      redirect_to set_account_email_path, alert: 'You must enter email to continue authorization'
    end
  end

  def oauth_params
    request.env['omniauth.auth']
  end
end
