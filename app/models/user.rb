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
         :omniauthable, omniauth_providers: [:github, :vkontakte]

  def owner?(resource)
    resource.user_id == self.id
  end

  def self.find_for_oauth(oauth)
    auth = Authorization.where(provider: oauth.provider, uid: oauth.uid.to_s).first
    return auth.user if auth

    find_or_create_user_and_oauth(oauth)
  end

  def self.find_or_create_user_and_oauth(oauth)
    email = oauth.info&.email || (return false)
    user = find_by(email: email)

    if user
      transaction do
        user.update!(confirmed_at: Time.zone.now)
        user.create_authorization!(oauth)
      end
    else
      transaction do
        user = create_user!(email)
        user.create_authorization!(oauth)
      end
    end
    user
  end

  def self.create_user!(email)
    password = Devise.friendly_token[0, 20]
    create!(email: email,
            password: password,
            password_confirmation: password,
            confirmed_at: Time.zone.now
    )
  end

  def self.create_user_and_auth!(email, provider, uid)
    transaction do
      password = Devise.friendly_token[0, 20]
      user = create!(email: email, password: password, password_confirmation: password)
      user.authorizations.create!(provider: provider, uid: uid)
      user
    end
  end

  def create_authorization!(oauth)
    authorizations.create!(provider: oauth.provider, uid: oauth.uid.to_s)
  end
end
