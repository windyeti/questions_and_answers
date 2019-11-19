class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :rewards, dependent: :destroy
  has_many :votes
  has_many :comments
  has_many :authorizations, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  def owner?(resource)
    resource.user_id == self.id
  end

  def self.find_for_oauth(oauth)
    auth = Authorization.where(provider: oauth.provider, uid: oauth.uid).first
    return auth.user if auth

    email = oauth.info[:email]
    user = User.where(email: email).first
    if user
      user.authorizations.create(provider: oauth.provider, uid: oauth.uid)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create(email: email, password: password, password_confirmation: password)
      user.authorizations.create(provider: oauth.provider, uid: oauth.uid)
    end
    user
  end
end
