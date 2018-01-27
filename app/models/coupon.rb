class Coupon < ApplicationRecord
	attr_acccessor :amount

	belongs_to :order
	belongs_to :user

	# "uid","name","type","limit","channel","description","status","start_date","end_date","property","shop_id","category_id","source_name","source_id","minimum_cost"


	module CouponTypes
		RangeTypes = %w(single all )
 		# 优惠券适用范围(单品，全场)

		PurchaseLimit = %w(discount cash limit)
    	# 使用条件（满减）

	end
end
