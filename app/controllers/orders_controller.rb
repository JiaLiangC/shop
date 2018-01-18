class OrdersController < ApplicationController


    def new
        fetch_home_data
        # 根据user_uuid找到用户所有购物车
        @shopping_carts = ShoppingCart.by_user_uuid(current_user.uuid).
        order("id desc").includes(product: [:cover_image])
    end


    def create

        # 根据user_uuid找到用户所有购物车
        shopping_carts = ShoppingCart.by_user_uuid(current_user.uuid).includes(:product)
        
        if shopping_carts.blank?
            redirect_to shopping_carts_path
            return
        end

        address = current_user.addresses.find(params[:address_id])
        
        # 根据所有购物车创建订单并跳转到支付页面
        orders = Order.create_order_from_shopping_carts!(current_user, address, shopping_carts)
        redirect_to generate_pay_payments_path(order_nos: orders.map(&:order_no).join(','))
    end

   


end
