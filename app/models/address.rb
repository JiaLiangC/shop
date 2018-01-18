class Address < ApplicationRecord
    belongs_to :user

    validates :user_id, presence: true
    validates :address_type, presence: true
    validates :contact_name, presence: {message: "收货人不能为空"}
    validates :mobile, presence: {message: "手机号不能为空"}
    validates :address, presence: {message: "地址不能为空"}



    # 地址分为订单地址和用户地址
    module AddressType
        User = 'user'
        Order = 'order'
    end

end
