module Api::SmsHelper
	def cmp(mobile, code)
		key = mobile.to_s
		redis_code = $redis.get(key)
		if redis_code != code
			raise "code error"
		end
	end
end
