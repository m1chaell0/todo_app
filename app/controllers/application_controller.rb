class ApplicationController < ActionController::Base
  include Authentication

  helper_method :current_user, :logged_in?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def current_user
    return @current_user if defined?(@current_user)

    session_id = cookies.signed[:session_id]
    if session_id
      user_session = Session.find_by(id: session_id)
      @current_user = user_session&.user
    end

    @current_user
  end

  def logged_in?
    current_user.present?
  end
end
