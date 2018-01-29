class CouponWorker
	include Sidekiq::Worker
	 
	def perform(batch_num, attributes, amount)
		puts batch_num, attributes, amount
		Rails.logger.info(batch_num, attributes, amount)

	end

end