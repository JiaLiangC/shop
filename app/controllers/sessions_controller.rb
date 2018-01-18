class SessionsController < ApplicationController
    def new
        redirect_to(root_url) if current_user
        @user = User.new
    end


    def auth_callback

        @title = '微信登录 结果页'
        auth_hash = request.env['omniauth.auth']
        @info = auth_hash

        openid = auth_hash.fetch('extra').fetch('raw_info').fetch("openid") rescue ''
        user_info = auth_hash.fetch('extra').fetch('raw_info')

        # redirect_to "/#!/login/1"
    end


    # 用户登陆
    def create

        # 验证账号为空
        unless user_params[:account].present?
          flash[:danger] = "帐号不能为空"
          return redirect_to login_url
        end

        # 判断是邮箱账户就用图像验证码，是手机用户就用短信验证码
        @user = User.find_by_account(user_params[:account])
        valid_rucaptcha =  verify_rucaptcha?
          
          #判断用户密码正确并且验证码正确 
        if @user && valid_rucaptcha && @user.authenticate(user_params[:password])


          if account_type(user_params[:account]) == "email" 
            
            #判断用户是否邮箱激活 
            if @user.is_verified_with?(:email)
              log_in(@user)
              redirect_to root_url
            else
              flash[:info] = "请激活你的帐户"
              redirect_to root_url
            end
          else
            log_in(@user)
            @user.update_attributes(sign_in_count: @user.sign_in_count+1)
            params[:user][:remember_me] == "1" ? remember(@user) : forget(@user) 
            redirect_to root_url
          end
        else
          # 用户登陆状态异常的处理
          if @user && !@user.authenticate(user_params[:password])
            @user.errors.add(:password, "密码错误")
          else
            @user.errors.add(:account,"帐户不存在")
          end

          if !valid_rucaptcha
            @user.errors.add(:base,"验证码错误")
            flash.now[:danger] = "验证码错误" 
          end
          render "new"
        end
    end

    def destroy
        log_out
        flash[:info] = "退出成功"
        redirect_to root_url
    end

    private
        def user_params
          params.require(:user).permit(:account,:_rucaptcha,:name,:email,:phone,:password,:password_confirmation,:verify_code)
        end

end
