class User < ApplicationRecord
  attr_accessor :account,:verify_code,:email_activation_token,:remember_token,
        :system_verify_data, :reset_token

  # 默认只选择已关注，取消关注不算
  # default_scope where(:subscribe => true)

  scope :subscribed, -> {where(subscribe: true)}

  validates_uniqueness_of :mobile, if: lambda{|u| u.mobile.present?}

  # validates :email, format: {with: Patterns.email},presence: true, :if => lambda{|u| u.email.present?}
  validates :mobile, format: {with: Patterns.mobile},presence: true, if: lambda{|u| u.mobile.present?}
  # validates :password, presence: true,length: {minimum: 6}
  # validate :check_verify_code, if: lambda{|u| u.mobile.present?},on: :create
  # validates :name, presence: true
  # validate :check_presence_of_account
  # validates_uniqueness_of :name
  # validates_uniqueness_of :email, if: lambda{|u| u.email.present?}
  validates_uniqueness_of :mobile, if: lambda{|u| u.mobile.present?}
  # validates_confirmation_of :password


  has_one :profile
  
  has_many :articles
  
  has_many :user_addresses
  
  has_many :orders
  
  has_many :payments

  has_secure_password

  has_many :member_scores

  def scores_expired?
  end


  #注册时验证邮箱或手机是否为空 
  def check_presence_of_account
    if(!self.account.present?) && !(self.mobile.present? || self.email.present?)
      self.errors.add(:account,"帐号不能为空")
    end
  end

  # 用书是否以（val）的方式验证过
  def is_verified_with?(val)
    raise "invalid param" unless [:email, :mobile].include?(val)
    return self.send "#{val}_verified"
  end

  # 用户是否已验证（通过邮箱或手机）
  def is_verified?
    self.email_verified || self.mobile_verified
  end

  # 用户重置密码时创建摘要
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.now)
  end

  # 发送重置密码邮件
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # 注册时发送激活账户邮件
  def send_active_email
    UserMailer.account_activation(self).deliver_now
  end

  # 用户邮件激活时，创建一个摘要
  def create_activation_digest
    self.email_activation_token =  User.new_token
    self.email_activation_digest = User.digest(email_activation_token)
  end
  
  #不为空，校验用户验证码
  def check_verify_code
    effective_time = 10.minute
    hash = self.system_verify_data.symbolize_keys!
    slef.errors.add(:verify_code,"验证码不合法") if verify_code_invalid?

  end

  # 用户验证码是否合法
  def verify_code_invalid?
    effective_time = 10.minute
    hash = self.system_verify_data.symbolize_keys!
    hash[:verify_code].blank? || (hash[:sent_at].to_time + effective_time) < Time.now && (self.verify_code != hash[:verify_code])
  end

  #生成新的记住密码时所用的摘要 
  def set_new_remember_digest
    self.remember_token = User.new_token
    update_attribute(remember_digest: User.digest(remember_token))
  end

  # bcrypt
  # attribute取值 [remember, email_activation, reset]
  # 用来验证token是否正确
  def authenticated?(attribute, token)
    digest = self.send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # 清楚记住密码生成的摘要
  def clear_remember_digest
      update_attribute(:remember_digest, nil)
  end

  # 用[邮箱，手机]激活账户啊
  def activate(activation_mode)
    default_activations = [:email, :mobile]

    if default_activations.include?(activation_mode)
      field_name = "#{activation_mode}_verified"
      send(:update_attribute, field_name,true) if respond_to?(field_name)
      # update_attribute(:email_verified, true)
      update_attribute(:activated_at, Time.now)
    else
      return nil
    end
  end

  # 限制重置密码的有效时间为2小时
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  #头像   
  def avatar
    profile.try(:avatar)
  end


  class  << self

    #生成摘要
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST
       : BCrypt::Engine.cost
       BCrypt::Password.create(string,cost: cost) 
    end

    #生成令牌 
    def new_token
      SecureRandom.urlsafe_base64
    end

    # 账户类型
    def account_type(account)
      return nil unless account.present?
      return 'email' if account =~ Patterns.email
      return 'mobile' if account =~ Patterns.mobile
      return 'name'
    end
    
    # 找到用户
    def find_by_account(val)
      account = account_type(val)
      send("find_by_#{account}",val) 
    end

  end
end
