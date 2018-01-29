class SmsWorker
  include Sidekiq::Worker

   def perform(mobile, validate_code)

        expires_time= 10

        key = mobile.to_s

        logger.info key

        $redis.set(key, validate_code)

        ChinaSMS.use :yunpian, password: Settings.yunpian.apikey

        tpl_params = { code: validate_code }
        ChinaSMS.to key, tpl_params, tpl_id: 2161074
        $redis.expire(key, expires_time * 60)
  end
  
end
