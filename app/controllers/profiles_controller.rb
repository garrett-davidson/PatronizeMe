class ProfilesController < ApplicationController
	def show
		respond_to do |format|
      		format.html { render :profile }
      		format.json { render json: @profiles }
    	end
	end
end
