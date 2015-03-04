class AdminDashboardController < ApplicationController
  protect_from_forgery with: :null_session
  before_filter :authenticate

  def index
  end

  def upload
    @picdump_image = PicdumpImage.new
  end

  def upload_action
    # handle external URL upload
    _params = picdump_image_params
    if !_params[:img_url].nil? and _params[:img_url] != ""
      _params[:img] = URI.parse(_params[:img_url])
      _params = _params.except(:img_url)
    end
    picdump_image = PicdumpImage.new(_params)

    picdump_image.save
    flash[:notice] = "Image uploaded"
    redirect_to :admin_dashboard_upload
  end

  def delete_picdump_image
    PicdumpImage.destroy(params[:image_id].to_i)
    redirect_to :back
  end

  def picdumps
    @images = PicdumpImage.where(:picdump_id => nil)
  end

  private

  def authenticate
    redirect_to :new_user_session if !user_signed_in? or current_user.admin == false
  end

  def picdump_image_params
    params.require(:picdump_image).permit(:title, :picdump_category_id, :img, :img_url)
  end
end
