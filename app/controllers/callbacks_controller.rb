class CallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.from_omniauth(request.env['omniauth.auth'])
    # check if user already exists
    if existing_user = User.find_by(provider: @user.provider, uid: @user.uid)
      sign_in existing_user
      redirect_to '/'
    else
      @provider = @user.provider
      @uid = @user.uid
      @email = @user.email
      @username = @user.username
      @name = @user.name
      render 'devise/registrations/new'
    end
  end

  def stripe_connect
    @user = current_user
    if @user.update_attributes({
                                   payment_provider: request.env["omniauth.auth"].provider,
                                   payment_uid: request.env["omniauth.auth"].uid,
                                   access_code: request.env["omniauth.auth"].credentials.token,
                                   publishable_key: request.env["omniauth.auth"].info.stripe_publishable_key
                               })
      # anything else you need to do in response..
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Stripe") if is_navigational_format?
    else
      session["devise.stripe_connect_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
