module ApplicationHelper

  def active_class(link_path)
    "active" if request.fullpath.start_with?(link_path)
  end

  def fdate(date)
    l(date, format: "%d de %B del %Y")
  end

  def ftime(date)
    date.strftime("%I:%M %P")
  end

  def fdatetime(date)
    l(date, format: "%d de %B del %Y a las %I:%M %P")
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def is_admin?
    current_user.user_type == User::ADMIN || current_user.user_type == User::SUPER_USER
  end

  def super_user?
    current_user.user_type == User::SUPER_USER
  end

end
