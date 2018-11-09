class SessionsController < ApplicationController
  skip_before_action :auth_required

  def create
    session[:user_email] = auth_hash['info']['email']
    respond_to do |format|
      if authenticated?
        format.html {redirect_to '/'}
      else
        format.html {redirect_to '/login', notice: 'No autorizado'}
      end
    end
  end

  def destroy
    reset_session
    redirect_to '/login'
  end

  def change_user
    if session[:is_super_user]
      set_user(params[:user_id])
    else
      redirect_to '/', notice: "No tiene permisos para esta opción"
    end
  end

  def failure
    render :plain => '403 Auth method has failed', :status => 403
  end

  protected
  def auth_hash
    request.env['omniauth.auth']
  end

  private
  def set_user(user_id)
    user = User.find(user_id)
    session[:user_id] = user.id
    redirect_to root_path, notice:"Viendo como #{user.name}"
  end
end