class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable, :timeoutable,
         :omniauth_providers => [:facebook, :twitter, :github, :reddit]

  before_save :default_values


  def default_values
    self.points ||= 0
  end

  def self.from_omniauth(auth, next_id)
    new_user = false
    user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.admin = true if next_id == 1000
      user.email = "anon#{next_id}@example.com"
      user.name = "anon#{next_id}"
      user.uid = auth.uid
      user.provider = auth.provider
      user.password = Devise.friendly_token[0,20]
      new_user = true
    end
    return new_user, user
  end

  def admin?
    admin
  end

  def timeout_in
    if self.admin?
      1.year
    else
      2.days
    end
  end

  has_many :generated_memes

end
