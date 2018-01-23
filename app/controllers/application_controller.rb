class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_local, :set_browser_uuid
  # protect_from_forgery with: :exception
  protect_from_forgery
  include SessionsHelper
  include ApplicationHelper
  # 设置语言
  def set_local
    I18n.locale= params[:locale] || I18n.default_locale
  end

  def account_type(account)
    return nil unless account.present?
    return 'email' if account =~ Patterns.email
    return 'mobile' if account =~ Patterns.mobile
    return 'name'
  end

  # 按层级打包所有商品分类
  def fetch_home_data
    @categories =  Category.grouped_data
  end

  # 为每一个浏览用户生成一个user_uuid，并存入cookie


  def set_browser_uuid

    uuid = cookies[:user_uuid]
    unless uuid
      #如果uuid不存在 ，且用户登陆了就取用户登陆后生成的uuid
      if logged_in?
        uuid = current_user.uuid
      else
        uuid = RandomCode.generate_utoken
      end
    end
    update_browser_uuid uuid
  end

  def update_browser_uuid(uuid)
    session[:user_uuid] = cookies.permanent['user_uuid'] = uuid
  end

  protected

  def current_weixin_user
    if !params[:code].blank? # weixin redirect
      # come from wechat menu
      sns_info = $client.get_oauth_access_token(params[:code])
      if sns_info.is_ok?
        # OAuth
        openid = sns_info.result[:openid]
        oauth_token = sns_info.result[:oauth_token]
        @current_user = User.find_by("open_id", openid)
        user_info = $client.get_oauth_userinfo(openid, oauth_token)

        if !@current_user
          # web端直接进入
          @current_user = User.new
          @current_user.open_id = openid
        end
        update_weixin_info(user_info)
        session[:user_id] = @current_user.open_id
      end
    else
      if session[:user_id].nil? || !(@current_user = User.find_by("open_id", session[:user_id]))
          redirect_to weixin_url
      end
    end
  end

  def update_weixin_info(user_info)
    @current_user.name = user_info.result[:nickname]
    @current_user.sex = user_info.result[:sex]
    @current_user.headimgurl = user_info.result[:headimgurl]
    @current_user.save
  end

  def is_wechat_broswer?
     !!( request.user_agent =~ /MicroMessenger(.*)/ )
  end

  def is_bind_mobile?
    !@current_user.mobile.blank?
  end
end
