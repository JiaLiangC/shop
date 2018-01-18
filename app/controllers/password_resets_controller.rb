class PasswordResetsController < ApplicationController
    before_action :get_user, only: [:edit, :update]
    before_action :valid_user, only: [:edit,:update]

    def new
    end



    # 密码重置
    def create
       
        account = params[:password_reset][:account]
        @user = User.find_by_account(account)
        account_tp = account_type(account)
        valid_rucaptcha =  verify_rucaptcha?
       
        # 用户已激活并且验证码正确
        if @user && valid_rucaptcha && @user.is_verified_with?(account_tp.to_sym)
            @user.verify_code = params[:password_reset][:verify_code]
            

            # 根据用户输入的账户类型来选择是发邮件还是短信
            if account_tp == "email"
                @user.create_reset_digest
                @user.send_password_reset_email
                flash[:info] = "已发送重置密码链接到您的邮箱了"
                redirect_to root_url
            end

            if account_tp == "mobile"
                @user.system_verify_data = get_verify_data 

                if @user.verify_code_invalid?
                    flash.now[:danger] = "非法的验证码"
                    render "new"
                else
                    digest = User.digest(@user.verify_code)
                    Rails.logger.info digest
                    # redirect_to edit_password_reset_path(digest,account: account)
                    redirect_to(action: :edit, id: @user.id,account: account,digest: digest)
                end
            end
        else
            flash.now[:danger] = "验证码错误" unless valid_rucaptcha
            render "new"
        end
    end

    def edit

    end

    # 更新密码
    def update

        if both_passwords_blank?
            falsh.now[:danger] = "密码不能为空"
            render "edit"
        elsif @user.update_attributes(user_params)
            log_in @user
            flash[:success] = "密码重置成功"
            clear_verify_data
            Sms.clear_limit(@user.mobile) if @user.mobile.present?
            redirect_to root_url
        else
            render "edit"
        end
    end

    private
        def user_params
            params.require(:user).permit(:password,:password_confirmation)
        end

        def both_passwords_blank?
            params[:user][:password].blank? &&
            params[:user][:password_confirmation].blank?
        end


        # 取得生成的手机验证码，用来和用户输入做比对
        def get_verify_data
            session[:sms_reset_password] || {}
        end

        # 
        def clear_verify_data
            session.delete(:sms_reset_password)
        end

        def get_user
            @user = User.find_by_account(params[:account])
        end


        # 在做编辑和更新用户资料时验证用户合法性
        def valid_user

            account = params[:account]
            account_tp = account_type(account)
            if @user && @user.is_verified_with?(account_tp.to_sym)
                if account_tp == "email" 
                    unless @user.authenticated?(:reset, params[:id])
                        flash[:info] = "激活链接已过期或错误"
                        redirect_to root_url
                    end
                elsif account_tp == "mobile"
                    digest = params[:digest]
                    token = get_verify_data["verify_code"]
                    unless BCrypt::Password.new(digest).is_password?(token)
                        flash[:info] = "非法的动作"
                        redirect_to root_url
                    end
                end
            else
                flash[:info] = "invalid activation link"
                redirect_to root_url
            end
        end
end
