Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

    root 'home#index'

    resources :home
    resources :sessions
    resources :password_resets
    resources :images
    resources :categories
    resources :products
    resources :shopping_carts

    resources :payments, only: [:index] do
        collection do
            get 'generate_pay'
            get 'pay_return'
            get 'pay_notify'
            get 'success'
            get 'failed'
        end
    end

    resources :users do

    end

    resources :addresses do
        put 'set_default'
    end

    resources :callbacks do
        collection do
          post 'image_upload_callback'
        end
    end

    resources :orders

    #注册 
    get 'signup' => 'users#new'
    post 'signup' => 'users#create'

    get 'sessions/auth_callback' => 'sessions#auth_callback'
    #登入登出
    get 'login' => 'sessions#new'
    post 'login' => 'sessions#create'
    delete 'logout' => 'sessions#destroy'
    get 'account_activation/:id',to: 'users#account_activation',as: :user_account_activation
    post 'users/send_verify_code' => 'users#send_verify_code'

    namespace :admin do
        require 'sidekiq/web'
        Sidekiq::Web.use Rack::Auth::Basic do |username, password|
          # - Use digests to stop length information leaking (see also ActiveSupport::SecurityUtils.variable_size_secure_compare)
            ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
            ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
        end if Rails.env.production?
        mount Sidekiq::Web => '/sidekiq'

        root "categories#index"
        resources :categories
        resources :products
        resources :product_images
        resources :coupons
    end

    # 验证微信公众号服务器
    get "/weixin" => 'weixin#auth_server'

    get "/weixin/example" => "weixin#example"

    scope :path => '/weixin', :via => :post do
        match "/", :to => 'weixin#method_text', :constraints => lambda{|request| Nokogiri::XML(request.raw_post).xpath('//MsgType').text == 'text'}
        match "/", :to => 'weixin#method_image', :constraints => lambda{|request| Nokogiri::XML(request.raw_post).xpath('//MsgType').text == 'image'}
        match "/", :to => 'weixin#method_location', :constraints => lambda{|request| Nokogiri::XML(request.raw_post).xpath('//MsgType').text == 'location'}
        match "/", :to => 'weixin#method_event', :constraints => lambda{|request| Nokogiri::XML(request.raw_post).xpath('//MsgType').text == 'event'}
    end

    namespace :api do

        resources :addresses do
            member do 
                put 'set_default'
            end
        end
        resources :sms, only: [:create] do
            collection do
                post 'verify'
            end
        end

        resources :products
    end
end











