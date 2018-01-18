redis = Redis.new :host => "127.0.0.1", :port => 6379, :db => 3
$redis = Redis::Namespace.new("sms", :redis => redis)

Sidekiq.configure_server do |config|
	config.redis = {url: "redis:127.0.0.1:6379/2", namespace: "plavest"}
	schedule_file = "config/schedule.yml"
	if File.exists?(schedule_file)
		Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
	end
end

Sidekiq.configure_client do |config|
	config.redis = {url: "redis:127.0.0.1:6379/2", namespace: "plavest"}
end