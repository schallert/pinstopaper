class Users::RegistrationsController < Devise::RegistrationsController
  def update
    session[:instapaper_username] = params[:user][:instapaper_username]
    session[:instapaper_password] = params[:user][:instapaper_password]
    super
  end

  private
  def sign_up_params
     params.require(:user).permit(:email, :password, :password_confirmation, :pinboard_token)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :pinboard_token, :instapaper_username, :instapaper_password)
  end
end
