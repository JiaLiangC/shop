class Image < ApplicationRecord
    
    #多态，图可以属于任意多个类， imgable_type 指定类名, imgable_id指定实例id 
    belongs_to :imgable, polymorphic: true

    # 
    after_save :update_imgable_by_imgble_type


    # 
    def  update_imgable_by_imgble_type        
        
        # 类型为user的图片更新后，更新用户的头像
        case self.imgable_type
        when 'User'
            user = User.find(self.imgable_id)
            user.profile.update_attributes(avatar: self.name)
        end

        puts "update user avatar"
    end

    # 拼出七牛的图片URL地址
    def img_url
        "http://7xsr0z.com2.z0.glb.clouddn.com/#{self.name}"
    end

end
