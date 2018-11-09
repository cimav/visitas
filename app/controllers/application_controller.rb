class ApplicationController < ActionController::Base
  before_action :auth_required
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  include ApplicationHelper

  def authenticated?
    if session[:user_auth].blank?
      user = User.find_by_email(session[:user_email])
      session[:user_auth] = user && user.email == session[:user_email]
      session[:is_super_user] = true if user.user_type == User::SUPER_USER rescue puts "usuario no encontrado"

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

  def to_excel(rows, column_order, sheetname, filename)
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet :name => sheetname
    header_format = Spreadsheet::Format.new :color => :black, :weight => :bold
    sheet1.row(0).default_format = header_format

    rownum = 0
    for column in column_order
      sheet1.row(rownum).push column
    end
    for row in rows
      rownum += 1
      for column in column_order
        sheet1.row(rownum).push row[column].nil? ? 'N/A' : row[column]
      end
    end
    t = Time.now
    filename = "#{filename}_#{t.strftime("%Y%m%d%H%M%S")}"
    book.write "tmp/#{filename}.xls"
    # send_file("tmp/#{filename}.xls", :type=>"application/ms-excel", :x_sendfile=>true)
    send_file "tmp/#{filename}.xls", :x_sendfile => true
  end



end
