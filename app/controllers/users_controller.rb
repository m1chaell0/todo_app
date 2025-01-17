class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  def new
    @user = User.new
  end

  def create
    @user = Users::Create.create(user_params)
    if @user.persisted?
      # Optionally log the user in immediately after sign-up:
      start_new_session_for @user
      redirect_to after_authentication_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    # Must permit password and password_confirmation as well
    params.require(:user).permit(:first_name, :last_name, :email_address, :password, :password_confirmation)
  end
end
