class CallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.from_omniauth(request.env['omniauth.auth'])

    # check if user already exists
    existing_user = User.find(provider: @user.provider, uid: @user.uid)
    logger.debug 'Found existing user'
    sign_in_and_redirect existing_user
  rescue ActiveRecord::RecordNotFound
    logger.debug 'Registering new user'
    render 'devise/registrations/new'
  end
end
