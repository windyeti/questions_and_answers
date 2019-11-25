module OmniauthMacros
  def mock_auth_github
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      'provider' => 'github',
      'uid' => '123545',
      'info' => {
        'email' => 'mockemail@mail.com'
      }
    })
  end
end
