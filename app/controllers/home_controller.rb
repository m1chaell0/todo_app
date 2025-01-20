class HomeController < ApplicationController
  skip_before_action :require_authentication, only: [ :index ]

  def index
    redirect_to tasks_path if logged_in?
  end
end
