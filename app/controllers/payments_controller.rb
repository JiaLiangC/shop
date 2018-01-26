class PaymentsController < ApplicationController

    protect_from_forgery execpt: [:alipay_notify]

    # before_action :auth_user, except: [:pay_notify]
    before_action :auth_request, only: [:pay_notify, :pay_return]
    before_action :find_and_validate_payment_no, only: [:pay_return, :pay_notify]


    def index
        params.permit(:payment_no)

        # 找到支付记录
        @payment = current_user.payments.find_by(payment_no: params[:payment_no])
        # 创建支付链接
        @payment_url = build_payment_url
        # 生成支付配置信息
        @pay_options = build_request_options(@payment)

        # 渲染支付页
    end

    def generate_pay
        params.permit(:order_no)
        binding.pry
        #取得用户所有订单 
        order = current_user.orders.where(order_no: params[:order_no]).first
        # 根据订单来创建支付信息
        payment = Payment.create_from_order!(current_user, order)
        # 跳转到支付页面
        redirect_to payments_path(payment_no: payment.payment_no)
    end

    def pay_return
        do_payment
    end

    def pay_notify
        do_payment
    end

    def success
    end

    def failed
    end


    private

        #是否支付成功 
        def is_payment_success?
            %w[TRADE_SUCCESS TRADE_FINISHED].include?(params[:trad_status])
        end


        # 根据支付结果跳转到成功或失败页
        def do_payment
            unless @payment.is_success?
                if is_payment_success?
                    @payment.do_success_payment!(params)
                    redirect_to success_payments_path
                else
                    @payment.do_failed_payment!(params)
                    redirect_to failed_payments_path
                end
            else
                redirect_to success_payments_path
            end
        end

        # 验证阿里支付的回调是否合法
        def auth_request
            unless build_is_request_from_alipay?(params)
                Rails.logger.info "PAYMENT DEBUG NON ALIPAY REQUEST: #{params.to_hash}"
                redirect_to failed_payments_path
                return
            end

            unless build_is_request_sign_valid?(params)
                Rails.logger.info "PAYMENT DEBUG ALIPAY SIGN INVALID: #{params.to_hash}"
                redirect_to failed_payments_path
            end
        end

        # 验证阿里支付的回调是否合法
        def build_is_request_from_alipay? result_options
            return false if result_options[:notify_id].blank?
            body = RestClient.get ENV['ALIPAY'] + "?" + {
                service: 'notify_verify',
                partner: ENV["ALIPAY_ID"],
                notify_id: result_options[:notify_id]
            }.to_query
            body == "true"
        end

        # 验证回调的签名是否正确
        def build_is_request_sign_valid result_options
            options = result_options.to_hash
            options.extract!("controller","action","format")
            if options["sign_type"] == "MD5"
                options["MD5"] == build_generate_sign(options)
            elsif options['sign_type'] == "RSA"
                build_rsa_verify?(build_sign_data(options.dup), options['sign'])
            end
        end

        # 使用生成的私钥签名
        def build_generate_sign options
            sign_data = build_sign_data(options.dup)
            if options["sign_type"] == "MD5"
                Digest::MD5.hexdigest(sign_data + ENV['ALIPAY_MD5_SECRET'])
            elsif options['sign_type'] == "RSA"
                build_rsa_sign(sign_data)
            end     
        end

        # 生成rsa签名
        def build_rsa_sign(data)
            private_key_path =  Rails.root.to_s + "/config/app_private_key.key"
            key ="-----BEGIN RSA PRIVATE KEY-----\nMIICXAIBAAKBgQC9MZvqLtUo8nmw0Q/Ft3pMgv0aN+aY9I8ZDR5LUOjyix8CqscdBL7RpZoryToHZ7BiS1ayk4weG0awuqGJ7FjI7QRubJh0fWxqK9F6NJ+0s4kqSbDkVui1RTwr3K+TARBL2GatjBv+BFa9hyGEVFxDAxY8uiBoKgFOyvMBdxGn8wIDAQABAoGARBvc3kR31mLcLixE+k+gBnVNeqfPKxc3gLQ5SLHa+p3czw/92FOCAmUUiFjLvCi21dv7XRRC5/+3xh2Z09Yy65v38NrkZzC49VXb9JgNaBjyLCRW7vexBmod6UMdH2PC0L1gG5p9ZnrOP5ae43cN5LYWEjrsejDJCkYtSnlOS0kCQQDe9+E4nhecWseT/h8bT2EhlsLpekTq/E0BnQ4UocREpw+G9jJGt1iyPjaomWQ1GNexVVRBWFSM0i6WsmIk+TndAkEA2TjTAdscqdvprYYYGIsaWcUffAtmssSCGRrlkFem3GsYtEIVknGaEPkWkPG5K+lOkLYm0eEvEDhvXkglSZoUDwJAMZYxGXVXTOeHgSs/4cP6lwy/Vkth7lykB5rVGdOMIbSBqIMyVTXLXQCnCUHr3j8jIQYYEdxCGXtY7xzG5PAkZQJAcXjAqViHmae6Yx4IWlHX+wsBTnA6Pqpud6TYRNW04bHEXu2ijTRw0er8wcyz+V9P3kJ49uxWBHgmnS6847zsOwJBAIT+xujUe6zVAOExgRIxRMJ/qY9Cwh/mAv3lCDfjyyOBZudGBYOPkas/HtoAdm3aMzU+ckEsU9izLLmzKKkOvvM=\n-----END RSA PRIVATE KEY-----\n"
            pri =  OpenSSL::PKey::RSA.new(key)
            # pri =  OpenSSL::PKey::RSA.new(File.read(private_key_path))
            signature = Base64.encode64(pri.sign('sha1', data))
            puts signature if Rails.env.development?
            signature
        end

        def build_rsa_verify?(data, sign)
            public_key_path = Rails.root.to_s + "/config/.alipay_public"
            pub = OpenSSL::PKey::RSA.new(File.read(public_key_path))

            digester = OpenSSL::Digest::SHA1.new
            sign = Base64.decode64(sign)
            pub.verify(digester, sign, data)
        end

        # 对需要签名数据进行过滤并合并为字符串
        def build_sign_data(data_hash)
            data_hash.delete_if {|k,v| k == "sign" || v.blank?}
            data = data_hash.to_a.map{|x| x.join('=')}.sort.join('&')
            puts data 
            data
        end

        # 查找支付记录
        def find_and_validate_payment_no
            @payment = Payment.find_by_payment_no(params[:out_trade_no])
            unless @payment
                if is_payment_success?
                    render text: "未找到支付单号，但是已经成功支付"
                else
                    render text: "未找到您的单号，同时您的支付没有成功，请返回重新支付"
                    return
                end
            end
        end
        
        #生成二维码支付 的配置信息
        # 待重构抽出接口
        def build_request_options(payment)
            pay_options = {
              "app_id" => Settings.alipay.appid,
              # PC 扫码支付
              "method" => 'alipay.trade.page.pay',
              "format" => "json",
              "charset" => "utf-8",
              "sign_type" => 'RSA',
              "sign" => "",
              "timestamp"=> Time.now.strftime("%Y-%m-%d %H:%m:%S"),
              "version" => '1.0',
              "biz_content" => {
                  "out_trade_no" => payment.payment_no,
                  "seller_id" => "2088102170079362",
                  "product_code" => "FAST_INSTANT_TRADE_PAY",
                  "total_amount"=> payment.total_money,
                  "subject" => "aaaaaa",
                  "qr_pay_mode" => "2",
                  "qrcode_width" => "4"
                  # "goods_type" => "1",
                }.to_json
            }
            pay_options.merge!("sign" => build_generate_sign(pay_options))
            pay_options
        end

        def build_payment_url
            # "#{Settings.alipay.gateway_url}?"
            "#{Settings.alipay.gateway_url}"

        end

end
