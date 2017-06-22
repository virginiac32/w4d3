class SessionsController < ApplicationController
  def new
    @session = Session.new
    render :new
  end

  def create
    @session = Session.new(session_params)
    if @session.save
      user = User.find_by_credentials(session_param)
      user.reset_session_token!
      redirect_to cats_url
    else
      flash.now[:errors] = @session.errors.full_messages
      render :new
    end
  end

  def destroy
    current_user.reset_session_token! if @current_user
    session[:session_token] = nil
  end

  private

  def session_params
    params.require(:session)
      .permit(:user_name, :password)
  end
end
