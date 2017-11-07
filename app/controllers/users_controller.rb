class UsersController < ApplicationController
  def index
    if logged_in
      @users = User.all
    else
      flash[:status] = :error
      flash[:result_text] = "You need to be logged in to do this"
      redirect_to root_path
    end
  end

  def show
    if logged_in
      @user = User.find_by(id: params[:id])
      render_404 unless @user
    else
      flash[:status] = :error
      flash[:result_text] = "You need to be logged in to do this"
      redirect_to root_path
    end
  end
end
