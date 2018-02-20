class CallbacksController < Devise::OmniauthCallbacksController
  def github
      # build user object
      @user = User.from_omniauth(request.env["omniauth.auth"])

      # check if user already exists

      begin
        existing_user = User.find(provider: @user.provider, uid: @user.uid)
        logger.debug 'true'
        sign_in_and_redirect existing_user
      rescue
        logger.debug @user.email
        redirect_to edit_user_registration_path(@user)


        logger.debug 'false'
      end

  end
end
