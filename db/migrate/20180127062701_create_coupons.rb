class CreateCoupons < ActiveRecord::Migration[5.0]
  def change
    create_table :coupons do |t|
        t.integer :order_id
        # 使用优惠券的订单

        t.string :uid
        # 优惠券uuid

     		t.string :name
     		# 优惠券名称
     		
     		t.string :type
     		# 优惠券适用范围(单品，全场，品类)

        t.string :limit
        # 使用条件（满减 折扣）
        t.decimal :limit_val
        # 条件值（折扣率 or 满减门槛）

        t.string :channel
        # 渠道

     		t.text :description
     		# 优惠券规则描述

     		t.string :status 
    		# 优惠券状态

     		t.date :start_date
     		# 生效时间

     		t.date :end_date
     		# 结束时间

     		t.decimal :property
     		# 优惠券面额

     		t.integer  :user_id
     		# 拥有者id
     		
     		t.integer :shop_id
     		# 店铺范围内的优惠券

     		t.string :source_name

        # （category or product）
     		t.integer :source_id
     		# 备用

        t.timestamps
    end
  end
end
