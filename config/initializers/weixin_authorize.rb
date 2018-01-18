$client ||= WeixinAuthorize::Client.new(Settings.weixin.appid, Settings.weixin.appsecret)

$menu = {
	"button" => [
		{
			"type"=> "view",
			"name"=> "关于天特味",
			"view"=> "https://hongbu.info"
		},
		{
			"name" => "福利生活",
			"sub_button" => [
				{
					"type"=> "view",
					"name"=> "新春豪礼",
					"url" => "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxf9b0c8941b018b09&redirect_uri=http%3A%2F%2Fhongbu.info%2Fwx%2Foauth&response_type=code&scope=snsapi_userinfo&state=123#wechat_redirect"
				},
				{
					"type"=> 'view',
					"name"=> "免费申领",
					"url" => "http://hongbu.info/"
				},
			]
		},
		{
			"name" => "会员专区",
			"sub_button" => [
				{
					"type" => "view",
					"name" => "我的主页",
					"url" => "x",
				},
				{
					"type" => "view",
					"name" => "我的活动",
					"url" => "x",
				},
				{
					"type" => "view",
					"name" => "注册绑定",
					"url" => "x",
				}
			]
		}
	]
}