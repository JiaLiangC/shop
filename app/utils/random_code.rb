module RandomCode
    class << self

        def generate_utoken(length=8)
            (0..length).inject(""){|token, _| token << rand(36).to_s(36)}
        end

        def generate_product_uuid
            Date.today.to_s.split("-")[1..-1].join << generate_utoken(6).upcase
        end

        def generate_order_uuid
            Date.today.to_s.split('-').join()[2..-1] << generate_utoken.upcase
        end
    end
end