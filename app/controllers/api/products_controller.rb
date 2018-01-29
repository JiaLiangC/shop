class Api::ProductsController <  Api::BaseController
	def index
		key = params[:key]
		type= params[:type]
		
		
		if type == Coupon::CouponTypes::RangeTypeSingle
			# 全部产品
			@products = Product.onshelf.order("id desc")  if key.blank?
			# 搜索产品
			@products = Product.where("title like ?", "%#{key}%")  if key.present?
		end
		
		if type == Coupon::CouponTypes::RangeTypeACategory
			# 全部分类 
			 @categories = Category.all if key.blank?
			# 搜索分类
			 @categories = Category.where("title like ?", "%#{key}%") if key.present?
		end


	end
end