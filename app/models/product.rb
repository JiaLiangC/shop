class Product < ApplicationRecord
    # 商品类
    
    belongs_to :category

    before_create :set_default_attrs

    has_many :images, as: :imgable

    has_one :cover_image, -> { order("weight desc") }, class_name: :Image, as: :imgable
    
    scope :onshelf, ->{ where(status: Status::On) }


    # 产品状态是上/下 线
    module Status
        On = 'on'
        Off = 'off'
    end

    def cover_img_url
        self.cover_image.img_url
    end
    

    private
        # 生成产品uid
        def set_default_attrs
            self.uuid = RandomCode.generate_product_uuid
        end
end