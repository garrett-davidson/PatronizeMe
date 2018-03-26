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

  def github_projects
    @project = Project.new
    @response = RestClient.get('https://api.github.com/users/'+ current_user.username + '/repos')
    @projects = JSON.parse(@response.body)
  end

  def index
    @users = User.all
  end

  def addfunds
    redirect_to new_user_session_path unless user_signed_in?
  end

  def updatesettings
    settings = params.require(:user).permit(:avatar, user_setting: [ :isPublic])
    if (settings[:avatar] != nil ) 
      current_user.avatar = settings[:avatar]
    end
    current_user.user_setting.update settings[:user_setting]
    current_user.save!
    redirect_to profile_path
  end
end
