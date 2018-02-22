class CallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.from_omniauth(request.env['omniauth.auth'])

    # check if user already exists
    if existing_user = User.find_by(provider: @user.provider, uid: @user.uid)
      sign_in existing_user
      redirect_to '/'
    else ActiveRecord::RecordNotFound
      @provider = @user.provider
      @uid = @user.uid
      @email = @user.email
      @username = @user.username
      @name = @user.name
      render 'devise/registrations/new'
    end
  end
end
