module SessionsHelper

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by_id(user_id)
    elsif (user_id = cookies.signed[:user_id].present?)
      user =  User.find_by_id(user_id)
      if user && user.authenticated?(:remember, cookies.signed[:remember_token])
        log_in(user)
        @current_user = user
      end
    end
  end


  def save_reset_token(user)
    session[:user_reset_token] = user.reset_token
  end

  # 记住密码
  # 生成新的rember_digest 存入数据库，并把对应的token存入cookie
  def remember(user)
    user.set_new_remember_digest
    cookies.permantent.signed[:user_id] = user.id
    cookies.permantent.signed[:remember_token] = user.remember_token
  end

  # 取消记住密码
  # 清除数据库中的remember_digest
  # 并删除cookie中的user_id 和token
  def forget(user)
    user.clear_remember_digest
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 登录 session 存入user id 
  def log_in(user)
    session[:user_id] = user.id
  end

  # 登出 清空session 
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # 是否登录
  def logged_in?
    !!current_user
  end

  # 某个操作后返回原地址或者新的地址
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # 存储当前的地址，以备后用
  def store_location
    session[:forwarding_url] = request.url if request.get
  end


end
