class ShoppingCart < ApplicationRecord
    #购物车 
    
    validates :user_uuid, presence: true
    validates :product_id, presence: true
    validates :amount, presence: true


    belongs_to :product
    scope :by_user_uuid, ->(user_uuid){where(user_uuid: user_uuid)}


    class << self

        #创建或更新 购物车
        # 一个购物车条目中只包含一个商品，同一个人的商品为登陆时用session中的 user_uuid 锁定，
        # 登陆后 user_uuid 更新到用户记录中

        def create_or_update!(options = {})
            cond = {
                user_uuid: options[:user_uuid],
                product_id: options[:product_id]
            }

            record = where(cond).first
            record.update_attributes!(options.merge(amount: record.amount + options[:amount])) if record
            create!(options) unless record
            return record
        end

    end
end
