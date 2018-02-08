class ProfilesController < ApplicationController
	def show
		respond_to do |format|
      		format.html { render :profile }
      		format.json { render json: @profiles }
    	end
	end
	private
	    # Use callbacks to share common setup or constraints between actions.
	    def set_profile
	      @profile = Profile.find(params[:id])
	    end

	    # Never trust parameters from the scary internet, only allow the white list through.
	    def project_params
	      params.fetch(:Profile, {})
	    end
end
