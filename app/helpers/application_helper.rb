module ApplicationHelper

  def fdate(date)
    l(date, format: "%d de %B del %Y")
  end

  def ftime(date)
    date.strftime("%I:%M %P")
  end

  def fdatetime(date)
    l(date, format: "%d de %B del %Y a las %I:%M %P")
  end

end
