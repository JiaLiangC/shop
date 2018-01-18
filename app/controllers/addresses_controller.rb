class AddressesController < ApplicationController
    # layout false
    before_action :check_login
    before_action :find_address, only: [:edit, :update, :destroy, :set_default]


    # 当前用户所有的地址
    def index
        # @user = User.find(params[:user_id])
        @addresses = current_user.addresses
    end


    def new
        @address = current_user.addresses.new
    end

    # 创建地址
    def create
        @address = current_user.addresses.new(address_params)

        if @address.save
           @addresses = current_user.reload.addresses
            @status = "success"
            flash[:success] = "创建成功"
        else
            flash.now[:danger] = "失败"
            @status = "failed"
        end
    end

    def edit
    end

    def update
        if @address.update_attributes(address_params)
            flash[:success] = "更新成功"
            redirect_to addresses_path(current_user)
        else
            flash[:info] = "更新失败"
            redirect_to addresses_path(current_user)
        end
    end

    def destroy
        # @address = Address.find(params[:id])
        @address.destroy
        redirect_to addresses_path(current_user)
    end



    # 设置默认用户地址
    def set_default
        default_addr = current_user.addresses.where(defaults: true).first
        default_addr.update_attributes(defaults: false)  if default_addr
        @address.update_attributes(defaults: true)
        redirect_to addresses_path(current_user)
    end


    private

    def address_params
        params.require(:address).permit(:address, :mobile, :zipcode, :contact_name, :address_type)
    end

    # 找到指定用户地址记录
    def find_address
        @address = current_user.addresses.find(params[:address_id])
    end


end
