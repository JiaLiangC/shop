class Category < ApplicationRecord
    # 管理分类的类

    has_ancestry orphan_strategy: :destroy
    has_many :products, dependent: :destroy

    # 品类优惠券
    has_many :coupons, as: :source


    before_validation :correct_ancestry

    
    # 
    def correct_ancestry
        self.ancestry = nil unless self.ancestry.present?
    end


    class << self

        #打包所有根分类下的数据,形式如下
        #[[root1,child1,child2],[root2,child1,child2]]
        def grouped_data

            Category.roots.inject([]) do |res, parent|
                row = []
                row << parent
                row << parent.children.order('weight desc')
                res << row
            end
        end
    end
end
