class ProfilesController < ApplicationController
	def show
		respond_to do |format|
      		format.html { render :profile }
      		format.json { render json: @profiles }
    	end
	end
  	def user
    	# params[:id] comes from the URL: /users/:id
    	@user = User.find(params[:id])
    	@owner = User.find(params[:id])
  	end
  	def index
  		@users = User.all
  	end

end
