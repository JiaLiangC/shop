class NotificationMailer < ApplicationMailer

	def error_email(user)
		mail(to: user.email, subject: "Controller #{user.Controller} 出现问题，请立即查看")
	end
end
