class ApplicationController < ActionController::Base
  before_action :auth_required
  before_action :allow_iframe_requests
  protect_from_forgery with: :exception

  def  authenticated?
    if session[:user_auth].blank?
      user = User.where(:email => session[:user_email]).first
      session[:user_auth] = user && user.email == session[:user_email]

      if session[:user_auth]
        session[:user_id] = user.id
      end
    else
      session[:user_auth]
    end
  end

  def auth_required
    redirect_to '/login' unless authenticated?
  end

  def allow_iframe_requests
    response.headers.delete('X-Frame-Options')
  end

end
