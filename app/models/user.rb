class User < ApplicationRecord
  has_many :questions, dependent: :delete_all
  has_many :answers, dependent: :delete_all

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def owner?(resource)
    resource[:user_id] == self[:id]
  end
end
