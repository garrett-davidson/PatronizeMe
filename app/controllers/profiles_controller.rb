class ProfilesController < ApplicationController
  PROJECTS_PER_PAGE = 10
	def show
		respond_to do |format|
      		format.html { render :profile }
      		format.json { render json: @profiles }
    	end
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
  end

end
