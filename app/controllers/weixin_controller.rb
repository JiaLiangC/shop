require 'digest'
class WeixinController < ApplicationController
	protect_from_forgery with: :null_session

	skip_before_action :verify_authenticity_token

	def method_text
		doc = Nokogiri::XML(request.raw_post)
		@content = doc.xpath('//Content').text
		@from_user = doc.xpath('//FromUserName').text
		@to_user = doc.xpath('//ToUserName').text
		@timestamp = Time.now.to_i
		render partial: 'weixin/text', layout: false, formats: 'xml'
	end

	def method_image

	end

	def method_location

	end

	def method_event
		doc = Nokogiri::XML(request.raw_post)

		@from_user = doc.xpath('//FromUserName').text
		@to_user = doc.xpath('//ToUserName').text
		@timestamp = Time.now.to_i
		event = doc.xpath('//Event').text
		logger.info "event is #{event}"
		user = User.find_by(open_id: @from_user)
		if event == 'subscribe'
			# 用户关注立刻获取用户信息
			user_info = $client.user(@from_user)
			logger.info "weixin user subscribe: #{user_info.result[:openid]}"
			user = User.new if user.blank?
			user.open_id = @from_user
			user.name = user_info.result[:nickname]
    		user.sex = user_info.result[:sex]
    		user.headimgurl = user_info.result[:headimgurl]
    		user.password = "12345678"
    		user.subscribe = true
    		user.save
    	elsif event == 'unsubscribe'
    		logger.info "weixin user unsubscribe: #{@from_user}"
    		user.subscribe = false
    		user.save
		end
		@content = "欢迎光临"
		render partial: 'weixin/text', layout: false, formats: 'xml'
		#$client.send_text_custom(@from_user,@content)
	end

	def auth_server
		begin
			if check_signature?(params["timestamp"], params["signature"], params["nonce"])
				render :plain => params["echostr"]
			end
		rescue => e
			render :plain => 'authenticate error'
		end
	end

	def example
		@name = "xujiuang"
		# partial:
		render 'weixin/example', layout: false, :formats => :xml
	end

	protected
	def check_signature?(timestamp, signature, nonce)
		token = "tPtoaHNIIrOLdaE9DUr66VQPVM0" # weixin token
		arr = [token, timestamp, nonce]
		arr = arr.sort
		sign = Digest::SHA1.hexdigest(arr.join)
		return true if sign == signature
		false
	end
end
