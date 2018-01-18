module Enums
    class << self
        Product_Status = {"off": "下架", "on": "上架"}
        Permited_Imgable_Class = ["Product","User"]
        MemberScoreTypes = %w(sign_in sign_up expired).each

        def product_status
            Product_Status
        end

        def permited_imgable_class
            Permited_Imgable_Class
        end

        def member_score_types
           MemberScoreTypes
        end
    end
end