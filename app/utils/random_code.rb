module RandomCode
    class << self

        def generate_utoken(length=8)
            (0..length).inject(""){|token, _| token << rand(36).to_s(36)}
            36x
            # 生成0-36的随机数并转换为36进制(1位)，然后pushd到token 数组 （生成对应长度的随机字符串）

        end

        def generate_product_uuid
            Date.today.to_s.split("-")[1..-1].join << generate_utoken(6).upcase
            # 日期+对应长度随机字符串
        end

        def generate_order_uuid
            Date.today.to_s.split('-').join()[2..-1] << generate_utoken.upcase
        end
    end
end