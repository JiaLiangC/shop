class SmsWorker
  include Sidekiq::Worker

  def perform(mobile, validate_code, expires_time= 10)
  	key = mobile.to_s
    $redis.set(key, validate_code)

    params = {}
    params["apikey"] = Rails.application.secrets.sms_apikey
    params["mobile"] = mobile
    params["text"] ="【plavest中国】感谢使用plavest，您的手机验证码是#{validate_code}。为了您能及时收到来自plavest的重要通知，请将该号码加入手机白名单。"

    uri = URI.parse("https://sms.yunpian.com/v2/sms/single_send.json")

    res = Net::HTTP.post_form(uri, params)

    if res.code == "200"
    	# 发送成功 设置过期时间
    	# 10 分钟内有效
    	$redis.expire(key, expires_time * 60)
      $redis.hincrby("send_time", mobile, 1)
    else
    	# 发送失败
    	# $redis.expireat("send_time", Date.tomorrow.to_time.to_i)
    	$redis.del(key)
    	# 发送错误给管理员
    end
  end
end
