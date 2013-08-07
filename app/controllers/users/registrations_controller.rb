class Users::RegistrationsController < Devise::RegistrationsController
  private
  def sign_up_params
     params.require(:user).permit(:email, :password, :password_confirmation, :pinboard_token)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :pinboard_token)
  end
end
