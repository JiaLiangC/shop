class Api::SmsController < Api::BaseController
	include Api::SmsHelper
	def create
		begin
			mobile = params[:mobile].to_s
			if mobile =~ Patterns.mobile
				@status = "success"
				@errmsg = ""
			else
				raise "mobile error"
			end
		rescue => e
			@status = "error"
			@errmsg = "请输入合法的手机号码"
		end
	end

	def verify
		begin
			mobile = params[:mobile].to_s
			code = params[:code].to_s
			cmp(mobile, code)
			render plain: 'success'
		rescue => e
			render plain: 'error'
		end
	end
end
