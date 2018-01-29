class CouponWorker
	include Sidekiq::Worker
	 
	def perform(batch_num, attributes, amount)
		puts batch_num, attributes, amount
		attributes.merge!(batch_num: batch_num)
		amount.to_i.times do |i|
			Coupon.create(attributes)
		end

	end

end