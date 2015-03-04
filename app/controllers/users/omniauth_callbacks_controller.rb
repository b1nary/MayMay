class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    next_id = User.maximum("id")
    next_id += 1000 if !next_id.nil?
    next_id = 1000 if next_id.nil?
    @user = User.from_omniauth(request.env["omniauth.auth"], next_id)
    sign_in_and_redirect @user
  end

  def twitter
    next_id = User.maximum("id")
    next_id += 1000 if !next_id.nil?
    next_id = 1000 if next_id.nil?
    @user = User.from_omniauth(request.env["omniauth.auth"], next_id)
    sign_in_and_redirect @user
  end

  def github
    next_id = User.maximum("id")
    next_id += 1000 if !next_id.nil?
    next_id = 1000 if next_id.nil?
    @user = User.from_omniauth(request.env["omniauth.auth"], next_id)
    sign_in_and_redirect @user
  end

  def reddit
    next_id = User.maximum("id")
    next_id += 1000 if !next_id.nil?
    next_id = 1000 if next_id.nil?
    @user = User.from_omniauth(request.env["omniauth.auth"], next_id)
    sign_in_and_redirect @user
  end
end
