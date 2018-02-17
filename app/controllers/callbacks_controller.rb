class CallbacksController < Devise::OmniauthCallbacksController
  def github
    begin
      # build user object
      @user = User.from_omniauth(request.env["omniauth.auth"])
      # check if user already exists
      begin
        where(provider: @user.provider, uid: @user.uid).first do |existing_user|
         sign_in_and_redirect existing_user
        end
      rescue
        # check for required info
        if @user.email not nil
          where(provider: @user.provider, uid: @user.uid).first_or_create do |new_user|
            sign_in_and_redirect new_user
          end
        else
          #render a page to get email
          where(provider: @user.provider, uid: @user.uid).first_or_create do |new_user|
            sign_in_and_redirect new_user
          end
            
        end





      end

      # if they don't and its from sign up then create user

      #   if they don't and its from sign up and they don't have required fields send to onboarding page

      # if they dont and it's from login tell client that user doesn't exist


    end
  end
end