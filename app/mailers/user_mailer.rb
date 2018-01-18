class UserMailer < ActionMailer::Base

  # require 'sendgrid-ruby'
  # include SendGrid
  require 'rest_client'

  # 用设计模式包装一个适配各种邮件服务的gem

  def account_activation(user)
    @user = user
    # data = JSON.parse('{
    #   "personalizations": [
    #     {
    #       "to": [
    #         {
    #           "email": "xiaoliangcaig@gmail.com"
    #         }
    #       ],
    #       "subject": "this is a test from cai"
    #     }
    #   ],
    #   "from": {
    #     "email": "xiaoliang@p_yam.com"
    #   },
    #   "content": [
    #     {
    #       "type": "text/html",
    #       "value": "Hello, Email!"
    #     }
    #   ]
    # }')
    # data["content"][0]["value"] = email_body

    # sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    # response = sg.client.mail._("send").post(request_body: data)
    # puts response.status_code
    # puts response.body
    # puts response.headers

    email_body = render "account_activation"
    # uri =URI("http://api.sendcloud.net/apiv2/mail/send")
    uri = URI(Settings.sendcloud.uri)
    api_key = Settings.sendcloud.api_key
    api_user = Settings.sendcloud.api_user
    Net::HTTP.post_form(uri, {:apiUser => api_user, 
      :apiKey => api_key,
      :from => "yamahainfo@yamaha.com",
      :fromName => "Yamaha",
      :to => user.email,
      :subject => "账户激活",
      :html => email_body})
  end



  def password_reset(user)
    @user = user
    email_body = render "password_reset"
    # uri = URI("http://api.sendcloud.net/apiv2/mail/send")
    uri = URI(Settings.sendcloud.uri)
    api_key = Settings.sendcloud.api_key
    api_user = Settings.sendcloud.api_user
    Net::HTTP.post_form(uri, {:apiUser => api_user, 
      :apiKey => api_key,
      :from => "yamahainfo@yamaha.com",
      :fromName => "Yamaha",
      :to => user.email,
      :subject => "密码重置",
      :html => email_body})
  end

end