class MainController < ApplicationController

  def index
    #ana sayfa
    if !cookies[:user_id].blank? && session[:user_id].blank?
      logger.debug("cookie bulundu")
      u = User.find(cookies[:user_id])
      if !u.blank?
        session[:user_id] = u.id.to_i
      end
    end
  end

  def register
    #register sayfası için
  end

  def about
    #about sayfası için
  end

  def contact
    #contact sayfası için
  end

  def attempt_login
    session[:user_id] = nil

    u = User.where(:email => params[:email]).first
    if u && u.authenticate(params[:password])
      session[:user_id] = u.id.to_i
    end

    unless session[:user_id].nil?
      if params[:cache_login] == "on"
        cookies[:user_id] = session[:user_id]
      else
        cookies[:user_id] = nil
      end
      if params[:login_org_url]
        redirect_to(params[:login_org_url])
      else
        redirect_to(root_path)
      end
    else
      flash.now[:notice] = "Kullanıcı adı/şifre kombinasyonu hatalı"
      render(main_login_path)
    end

  end

  def login
    session[:user_id] = nil
    cookies[:user_id] = nil
  end

  def logout
  session[:user_id] = nil
  cookies[:user_id] = nil
  redirect_to(root_path)
end

def new_user

  session[:user_id] = nil
  cookies[:user_id] = nil


  if params[:name] == ""
    flash.now[:notice] = "Lütfen ad soyad giriniz"
    render('register')
    return
  end

  if params[:password] == ""
    flash.now[:notice] = "Lütfen bir şifre giriniz"
    render('register')
    return
  end

  if params[:email] == ""
    flash.now[:notice] = "Lütfen email adresinizi giriniz"
    render('register')
    return
  end

  if params[:password] != params[:password2]
    flash.now[:notice] = "Lütfen 2 kere aynı şifreyi giriniz"
    render('register')
    return
  end

  u = User.where(:email => params[:email]).first
  unless u.nil?
    flash.now[:notice] = "Bu email kullanımda, daha önce kaydolmuş olabilir misin?"
    render('register')
    return
  end

  u = User.where(:name => params[:name]).first
  unless u.nil?
    flash.now[:notice] = "Bu ad soyad kullanımda, daha önce kaydolmuş olabilir misin?"
    render('register')
    return
  end

  u = User.new
  u.name = params[:name]
  u.email = params[:email]
  u.password = params[:password]
  u.auth_level = 1


  if u.save
    session[:user_id] = u.id.to_i
    redirect_to(root_path)
  else
    flash.now[:notice_new] = "Kullanıcı yaratılırken sorun oluştu!"
    render('register')
  end

end

def add_comment

  @cmnt= Comment.new

  isvalid = true
  @validity_error = ""

  if params[:comment].blank?
    isvalid = false
    @validity_error = "İçi boş yorumlar göndermeyiniz."
  end

  if !isvalid
    if params[:refmodel_type] == "Post"
      redirect_to post_path(params[:refmodel_id])
    end
    return
  end

  @cmnt.user_id = current_user.id
  @cmnt.caption = params[:caption]
  @cmnt.comment = ActionController::Base.helpers.sanitize(params[:comment],{:tags => ["spoiler"]})
  @cmnt.refmodel_type = params[:refmodel_type]
  @cmnt.refmodel_id = params[:refmodel_id]

  @cmnt.save

  if params[:refmodel_type] == "Post"
    if @cmnt.refmodel.comment_count.blank?
       @cmnt.refmodel.comment_count = 1
    else
      @cmnt.refmodel.comment_count += 1
    end
    @cmnt.refmodel.save
    redirect_to post_path(params[:refmodel_id])
  elsif params[:refmodel_type] == "Event"
      if @cmnt.refmodel.comment_count.blank?
         @cmnt.refmodel.comment_count = 1
      else
        @cmnt.refmodel.comment_count += 1
      end
      @cmnt.refmodel.save
      redirect_to event_path(params[:refmodel_id])
  end


end

def delete_comment

  s_notice = ""

  @cmnt = Comment.where(:id => params[:comment_id]).first

  if @cmnt.user_id == current_user || current_user.auth_level == 9

    @cmnt.destroy

    if params[:refmodel_type] == "Post"
      @cmnt.refmodel.comment_count -= 1
      @cmnt.refmodel.save
      redirect_to post_path(params[:refmodel_id]) , notice: s_notice
    elsif params[:refmodel_type] == "Event"
        @cmnt.refmodel.comment_count -= 1
        @cmnt.refmodel.save
        redirect_to event_path(params[:refmodel_id]) , notice: s_notice
    end

  else
    #redirect_to @book_print, notice: "Geçersiz istek #{params[:comment_id]} #{params[:id]} #{cmnt.user_id} #{session[:userid]}"
    s_notice = "Geçersiz istek!"
  end


end


end
