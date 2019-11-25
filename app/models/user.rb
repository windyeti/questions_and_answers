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
         :confirmable,
         :omniauthable, omniauth_providers: [:github]

  def owner?(resource)
    resource.user_id == self.id
  end

  def self.find_for_oauth(oauth)
    auth = Authorization.where(provider: oauth.provider, uid: oauth.uid).first
    return auth.user if auth

    find_or_create_user_and_oauth(oauth)
  end

  def self.find_or_create_user_and_oauth(oauth)
    email = oauth.info[:email] || (return false)
    user = User.find_by(email: email) || create_user(email) || (return false)
    user.authorizations.create(provider: oauth.provider, uid: oauth.uid)
    user
  end

  def self.create_user(email)
    password = Devise.friendly_token[0, 20]
    User.create(email: email, password: password, password_confirmation: password)
  end
end
