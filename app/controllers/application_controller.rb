class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :require_login

  def render_404
    # DPR: supposedly this will actually render a 404 page in production
    raise ActionController::RoutingError.new('Not Found')
  end

private
=begin
  def find_user
    if session[:user_id]
      @login_user = User.find_by(id: session[:user_id])
    end
  end
=end
  def require_login
    @user = User.find_by(id: session[:user_id])
    unless @user
      flash[:status] = :failure
      flash[:message] = "You must be logged in to do that"
      redirect_to root_path
    end
  end
=begin
  def logged_in
    return session[:user_id] != nil
  end
=end
end
