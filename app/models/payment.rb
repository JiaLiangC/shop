class Payment < ApplicationRecord
    belongs_to :user
    has_one :order
    before_create :gen_pay_no


    # 支付状态
    module PaymentStatus
        Initial = 'initial'
        Success = 'success'
        Failed = 'failed'
    end


    #根据订单中创建支付记录，并把支付记录和订单关联起来
    def self.create_from_order! user, order

        payment = nil
        transaction do
            payment = user.payments.create!(
            total_money: order.total_money)
            if order.is_paid?
                raise "order #{order.order_no} has already paid"
            end
            order.payment = payment
            order.save!
        end
        payment
    end

    # 判断支付是否成功
    def is_success?
        slef.status == PaymentStatus::Success
    end

    # 根据支付宝返回数据判断是否支付成功
    def do_success_payment! options
        self.transaction do 
            self.transaction_no = options[:trade_no]
            self.status = Payment::PaymentStatus::Success
            slef.raw_response = options.to_json
            slef.payment_at = Time.now
            slef.save!

            self.orders.each do |order|
                if order.is_paid?
                    raise "order #{order.order_no} has already paid"
                end

                order.status = Order::OrderStatus::Paid
                order.payment_at = Time.now
                order.save!
            end
        end
    end

    # 根据支付宝返回数据判断是否支失败
    def do_failed_payment! options
        slef.transaction_no = options[:trade_no]
        self.status = Payment::PaymentStatus::Failed
        self.raw_response = options.to_json
        slef.payment_at = Time.now
        slef.save!
    end


    private
        # 生成支付记录的uid
        def gen_pay_no
            self.payment_no = RandomCode.generate_utoken(32)
        end

end
