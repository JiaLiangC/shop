# require 'china_sms'
module Sms
  extend self

  def send_to(mobile,content,sms_service_provider=:yunpian)
    raise "invalid phone number" unless mobile =~ Patterns.mobile
    raise "content can't be blank" if content.blank?
    raise "#{sms_service_provider} is not supplied"  unless [:tui3, :yunpian, :smsbao, :chanyoo, :emay, :luosimao].include?(sms_service_provider)
    ChinaSMS.use(sms_service_provider, password: Settings.yunpian.aaq) 
    ChinaSMS.to(mobile, content) unless Rails.env.development?
  end


  def send_verify_code(mobile, code, effective_time=10)
    content = "【雅马哈中国】感谢使用雅马哈，您的手机验证码是#{code}。为了您能及时收到来自雅马哈的重要通知，请将该号码加入手机白名单。"
    send_to(mobile,content) unless Rails.env.development?
    Rails.logger.info "sms code #{code} sent" if Rails.env.development?
    update_mobile_limit(mobile) unless Rails.env.development?
    return code
  end


  def random_code
    6.times.collect{rand(10)}.join
  end

  def redis_hash
    @redis_hash ||= Redis::HashKey.new("mobile-sms-limits", :marshal => true)
  end
  
  #指定限制规则 
  # 两次发送时间间隔必须大于1分钟
  # 短信有效时间为2h
  # 一天最多发20条
  def verify_mobile_send_limit(mobile)
    max = 20
    re_send_duration = 1.minute
    limit = redis_hash[mobile]
    return true if limit.blank?
    if (limit[:first_sent_at] + 1.day) < Time.now
      clear_limit(mobile)
      return true
    end
    limit[:sent_count] < max && (limit[:last_sent_at] + re_send_duration ) < Time.now
  end

  # 每次发完短信后更新短信的纪录状态,只在注册时使用，防爆破
  def update_mobile_limit(mobile)
    limit = redis_hash[mobile]
    if limit.present?
      limit[:sent_count] +=1
      limit[:last_sent_at] = Time.now
    else
      now = Time.now
      limit = {sent_count: 1,last_sent_at: now,first_sent_at: now}
    end
    redis_hash[mobile] = limit
  end

  def is_limited?(mobile)
    !verify_mobile_send_limit(mobile)
  end

  def clear_limit(mobile)
    redis_hash.delete(mobile)
  end

end