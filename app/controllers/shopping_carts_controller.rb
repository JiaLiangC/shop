class ShoppingCartsController < ApplicationController

    before_action :find_shopping_cart, only: [:update, :destroy]

    def index
        # 按层级返回所有分类
        fetch_home_data

        # 根据session中的user_uuid找到所有购物车记录
        @shopping_carts = ShoppingCart.by_user_uuid(session[:user_uuid])
        .order('id desc').includes([:product => [:cover_image]])
    end

    def edit

    end


    # 根据用户动作创建或者更新购物车item
    def create
        amount = 1
        @product = Product.find(params[:product_id])
        # create_or_update!数量在此方法中处理
        @shopping_cart = ShoppingCart.create_or_update!(
            user_uuid: session[:user_uuid],
            product_id: params[:product_id],
            amount: amount)
    end

    def update
    end

    def destroy
        @shopping_cart = ShoppingCart.find(params[:id])
        @shopping_cart.destroy
        redirect_to shopping_carts_path
    end


    private

        # 在更新或者删除前找到购物车记录
        def find_shopping_cart
            @shopping_cart = ShoppingCart.by_user_uuid(session[:user_uuid])
            .where(id: params[:id]).first
        end
end
