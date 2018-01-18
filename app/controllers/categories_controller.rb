class CategoriesController < ApplicationController

	# 
    def show
        fetch_home_data
        @category = Category.find(params[:id])
        # 取得该分类下所有上上架的商品
        @products = @category.products.onshelf.paginate(page: params[:page],per_page: 20)
        .order("id desc").includes(:cover_image)
    end
end
