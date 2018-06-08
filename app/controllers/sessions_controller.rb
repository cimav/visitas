class SessionsController < ApplicationController
  skip_before_action :auth_required

  def create
    session[:user_email] = auth_hash['info']['email']

    if authenticated?
      redirect_to '/'
    else
      render 'login/unauthorized', :status => 401, layout: 'empty_layout'
    end
  end

  def destroy
    reset_session
    redirect_to '/login'
  end

  def failure
    render :plain => '403 Auth method has failed', :status => 403
  end

  protected
  def auth_hash
    request.env['omniauth.auth']
  end
end