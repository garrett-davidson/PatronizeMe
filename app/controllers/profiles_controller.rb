class ProfilesController < ApplicationController
  PROJECTS_PER_PAGE = 10
  def profile
    redirect_to new_user_session_path unless user_signed_in?
  end

  def settings
    redirect_to new_user_session_path unless user_signed_in?
  end

  def user
    @user = User.find(params[:id])
    @owner = User.find(params[:id])
    offset = params.permit(:p)[:p]&.to_i || 1
    # params[:id] comes from the URL: /users/:id
    @current_page = offset
    @page_count = (@user.issue_transactions.count / PROJECTS_PER_PAGE.to_f).ceil
    offset -= 1
  end
  def index
    @users = User.all
  end

  def addfunds
    redirect_to new_user_session_path unless user_signed_in?
  end

  def updatesettings
    test = params.require(:user).permit(:avatar, user_setting: [ :isPublic])
    current_user.avatar = test[:avatar]
    current_user.user_setting.update test[:user_setting]
    current_user.save!
  end
end
