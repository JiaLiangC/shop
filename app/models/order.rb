class Order < ApplicationRecord
    validates :user_id, presence: true
    validates :address_id, presence: true
    validates :product_id, presence: true
    validates :total_money, presence: true
    validates :amount, presence: true
    validates :order_no, uniqueness: true

    belongs_to :user
    belongs_to :product
    belongs_to :address
    belongs_to :payment
    has_one :order_address

    before_save :gen_order_no


    # 订单状态，初始化和已支付两种，paid在支付成功后更新
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

            shopping_carts.flatten!
            address_attrs = address.attributes.except!("id", "created_at", "updated_at","type")
            orders = []
            transaction do

                order_address = user.order_addresses.create!(address_attrs)
                # create_order_contact()
                
                shopping_carts.each do |shopping_cart|
                    orders << user.orders.create(
                        product_id: shopping_cart.product.id,
                        address_id: order_address.id,
                        amount: shopping_cart.amount,
                        total_money: shopping_cart.amount*shopping_cart.product.price)

                end
                shopping_carts.map(&:destroy!)
            end
            orders
        end
    end


    private
        
        #生成订单号 
        def gen_order_no
            self.order_no = RandomCode.generate_order_uuid
        end

end
