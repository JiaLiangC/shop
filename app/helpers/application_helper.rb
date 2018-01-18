module ApplicationHelper
  require 'qiniu'
  include CategoriesHelper


  # 检查用户是否登录
  def check_login
    redirect_to signup_path  unless logged_in?
  end

  # 根据参数来判断是否处于某个controller中
  def active_class(val)
    return "active" if controller_name == val
  end
  
  # 生成购物车的加入购物车按钮
  def show_add_to_cart(product, options = {})
    html_class = "btn btn-danger add-to-cart-btn"
    html_class += "#{options[:html_calss]}" unless options[:html_calss].blank?
    link_to "<i class='fa fa-spinner'> </i> 加入购物车".html_safe, 
    '#', class: html_class, 'data-product-id': product.id, "data-turbolinks": false
  end

  # collection 参数为对象集合
  # 定制list
  # columns 参数为生成几列 ，默认为3列
  # thumbnail 参数为item所展示的缩略图
  # title 参数为item 标题
  # description 参数为item 描述
  # 

  def titled(collection, opt={})
    raise "link option is required" unless opt[:link]
    opt[:columns] ||= 3
    opt[:thumbnail] ||= ->(item){image_tag(item.cover_img_url)}
    opt[:title] ||= ->(item){item.title}
    opt[:description] ||= ->(item){item.description} if opt[:description] != false
    # opt[:price] ||= ->(item){item.price} if opt[:price] != false

    render "shared/titled_table",
    collection: collection,
    columns: opt[:columns],
    link: opt[:link],
    thumbnail: opt[:thumbnail],
    title: opt[:title],
    description: opt[:description],
    price: opt[:price],
    add_to_cart: opt[:add_to_cart]
  end



  # 拼七牛的图片地址
  def image_path(hash)
    return "http://7xsr0z.com2.z0.glb.clouddn.com/#{hash}"
  end


  # 显示用户头像
  def gravatar_for(user, options = {width: "100"})
    width = options[:width]
    # 2根据图片在七牛的hash显示图片
    # @image=user.
    defaultpic='da8e974dc_xl.jpg'
    if user.avatar.present?
      image_tag(qiniu_image_by_hash(user.avatar, format: "square", width: width))
    else
      image_tag(qiniu_image_by_hash(defaultpic, format: "square", width: width))
    end
  end

  # 生成七牛的token
  def generate_qiniu_upload_token
    # bucket = "chenxiyue"
    Qiniu.establish_connection! access_key: Settings.qiniu.access_key, secret_key: Settings.qiniu.secret_key
    bucket = Settings.qiniu.bucket
    puts bucket
    puts Settings.qiniu.access_key
    put_policy = Qiniu::Auth::PutPolicy.new(bucket) #参数是七牛bucket名
    # put_policy.scope!("chenxiyue",key)
    callback_body = {
      fname: '$(fname)',
      hash: '$(etag)',
      imgable_id:  '$(x:imgable_id)',
      imgable_type: '$(x:imgable_type)',
      user_id: '$(x:user_id)',
      return_url: '$(x:return_url)'
    }.to_json
    # 构建回调策略，这里上传文件到七牛后， 七牛将文件名和文件大小回调给业务服务器.
    # callback_body = 'filename=$(fname)&filesize=$(fsize)' # 魔法变量的使用请参照 http://developer.qiniu.com/article/kodo/kodo-developer/up/vars.html#magicvar
    # put_policy.callback_url= upload_callback_users_url
    put_policy.callback_body= callback_body
    put_policy.callback_url= image_upload_callback_callbacks_url  #上传成功后回调的URL
    Qiniu::Auth.generate_uptoken(put_policy)
  end

  # 根据七牛返回的hash和图片参数 拼出URL
  # 根据不同参数 七牛会对图片进行加工，返回不同样式图片
  def qiniu_image_by_hash(hash, opt={})
    url = "http://7xsr0z.com2.z0.glb.clouddn.com/#{hash}"    #为了方便硬编码七牛的域名
    format = opt[:format]
    width = opt[:width]
    height = opt[:height]

    case format
    when "square"
      url << "?imageView2/1/w/#{width}/h/#{width}/q/90"
    when "preview"
      url << "?imageView2/2/w/#{width}/h/#{height}/q/90"
    else
      url
    end
  end

  # Override the filename of the uploaded files:
  # 生成图片名，防重复
  def filename
    @name = Digest::MD5.hexdigest(Time.now.utc.to_i.to_s + '-' + Process.pid.to_s + '-' + ("%04d" % rand(9999)))
    "#{@name}"
  end

  # 产品状态
  def products_status_options
    Enums.product_status.map{|k,v| [v,k]}
  end


end
