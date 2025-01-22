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

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to edit_user_path(@user), notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def change_password
    @user = current_user
  end

  def update_password
    @user = current_user
    form = ActiveType.cast(@user, Users::ChangePassword)
    if form.update(update_password_params)
      redirect_to edit_password_user_path(@user), notice: "Password updated successfully."
    else
      @user = form
      render :change_password, status: :unprocessable_entity
    end
  end

  private

  def user_params
    # Must permit password and password_confirmation as well
    params.require(:user).permit(:first_name, :last_name, :email_address, :password, :password_confirmation)
  end

  def update_password_params
    params.require(:user).permit(:current_password, :new_password, :password_confirmation)
  end
end
