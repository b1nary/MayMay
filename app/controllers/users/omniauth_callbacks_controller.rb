class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    next_id = User.maximum("id")
    next_id += 1000 if !next_id.nil?
    next_id = 1000 if next_id.nil?
    new_user, @user = User.from_omniauth(request.env["omniauth.auth"], next_id)
    give_referrer_points if new_user
    sign_in_and_redirect @user
  end

  def twitter
    next_id = User.maximum("id")
    next_id += 1000 if !next_id.nil?
    next_id = 1000 if next_id.nil?
    new_user, @user = User.from_omniauth(request.env["omniauth.auth"], next_id)
    give_referrer_points if new_user
    sign_in_and_redirect @user
  end

  def github
    next_id = User.maximum("id")
    next_id += 1000 if !next_id.nil?
    next_id = 1000 if next_id.nil?
    new_user, @user = User.from_omniauth(request.env["omniauth.auth"], next_id)
    give_referrer_points if new_user
    sign_in_and_redirect @user
  end

  def reddit
    next_id = User.maximum("id")
    next_id += 1000 if !next_id.nil?
    next_id = 1000 if next_id.nil?
    new_user, @user = User.from_omniauth(request.env["omniauth.auth"], next_id)
    give_referrer_points if new_user
    sign_in_and_redirect @user
  end

  private

  def give_referrer_points
    meme_view = MemeView.where( user_hash: Digest::MD5.hexdigest(request.remote_ip) ).order(:created_at => :asc).first
    
    if meme_view and meme_view.generated_meme and meme_view.generated_meme.user
      meme_view.generated_meme.user.points = 0 if meme_view.generated_meme.user.points.nil?
      meme_view.generated_meme.user.points += 50
      meme_view.generated_meme.user.save
    end
  end
end
