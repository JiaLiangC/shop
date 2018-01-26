class Order < ApplicationRecord
    validates :user_id, presence: true
    validates :address_id, presence: true
    # validates :product_id, presence: true
    validates :total_money, presence: true
    validates :amount, presence: true
    validates :order_no, uniqueness: true

    
    belongs_to :user
    
    # belongs_to :product

    belongs_to :addrdent
    belongs_to :payment
    has_one :order_address
    has_many :order_details

    before_save :gen_order_no


    # 订单状态，初始化和已支付两种，paid在支付成功后更新
    # 订单状态 (order_status,未付款,已付款,已发货,已签收,退货申请,退货中,已退货,取消交易)
    # 订单状态 (0:未审核或发起交易;1:交易完成;20:核单通过;24:核单失败;30:已发货;未签收;34:仓库退回;40:座席取消;41:买家取消;42:逾期取消;43:订单无效取消;50:客户签收;54:客户拒签;55:客户退货)
    module OrderStatus
        Initial = 'initial'
        Paid = 'paid'
    end


    # 是否支付
    def is_paid?
        self.status == OrderStatus::Paid
    end

    # 
    class << self

        #从购物车中创建订单 
        def create_order_from_shopping_carts!(user, address, *shopping_carts)
            order = nil
            shopping_carts.flatten!
            address_attrs = address.attributes.except!("id", "created_at", "updated_at","type")
            transaction do
                order_address = user.order_addresses.create!(address_attrs)
                total_money = shopping_carts.inject(sum = 0){|sum,shopping_cart| sum + shopping_cart.amount*shopping_cart.product.price}
                order = user.orders.create!(address_id: order_address.id,
                    amount: shopping_carts.count,
                    total_money: total_money)

                shopping_carts.each do |shopping_cart|
                    order.order_details.create!(
                        product_name: shopping_cart.product.title,
                        product_price: shopping_cart.product.price,
                        number: shopping_cart.amount,
                        product_cover_url: shopping_cart.product.cover_img_url,
                        subtotal: shopping_cart.amount*shopping_cart.product.price)

                end
                shopping_carts.map(&:destroy!)
            end
            order
        end
    end
   

    private
        
        #生成订单号 
        def gen_order_no
            self.order_no = RandomCode.generate_order_uuid
        end

end
