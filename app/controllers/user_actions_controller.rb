class UserActionsController < ApplicationController
  def change_name
    if !user_signed_in? or current_user.name != "anon#{current_user.id+999}"
      redirect_to :back
    else

    end
  end

  def change_name_action
    if user_signed_in? and current_user.name == "anon#{current_user.id+999}"
      usr = ApplicationHelper.sanitize_filename(params[:username])
      current_user.name = usr
      current_user.save
      flash[:info] = "Username changed"
      redirect_to root_path
    else
      redirect_to :back
    end
  end
end
